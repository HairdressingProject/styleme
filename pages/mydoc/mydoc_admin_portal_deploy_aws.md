---
title: Admin Portal Deployment - AWS
keywords: Admin portal, Api
last_updated: September 18, 2020
tags: [api]
summary: "This document outlines how to deploy the Admin Portal to an AWS EC2 instance."
sidebar: mydoc_sidebar
permalink: mydoc_admin_portal_deploy_aws.html
folder: mydoc
---

## Table of contents

- [Deployment](#Deployment)

## Development Stack

LAMPD - Linux / Apache / MariaDB / PHP / .NET Core

## Deployment

To successfuly deploy this web application, we require to follow several steps

### 1a. Create account and EC2 instance

Create an account on AWS and a new EC2 instance (**t2.medium**).

This [tutorial](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html "EC2 Tutorial - AWS docs") might help.

### 1b. Enabling HTTP/HTTPS access

In your AWS EC2 console, navigate to the Security tab, click on your security group and then "Edit inbound rules".

Add two new rules:

For HTTP:

- Type: HTTP
- Protocol: TCP
- Port range: 80
- Source: Custom
- Origin IP: 0.0.0.0/0 (All IPs)

For HTTPS:

- Type: HTTPS
- Protocol: TCP
- Port range: 443
- Source: Custom
- Origin IP: 0.0.0.0/0 (All IPs)

If you are not sure how to do that, read [this](https://aws.amazon.com/premiumsupport/knowledge-center/connect-http-https-ec2/ "Connecting to the EC2 instance through HTTP or HTTPS").

### 1c. Accessing your EC2 instance

Assuming that you have downloaded your private SSH key to access the EC2 instance (from the previous step), copy the public IPv4 DNS (available in your EC2 dashboard) and run the command below to access it:

```bash
ssh -i <your key.pem> ubuntu@<your IPv4 DNS>
```

You will be logged in as root.

In order to not lose access to your instace after you log out, remember to save your private key file safely and update the firewall settings:

```bash
sudo ufw allow ssh
```

### 2. Install and set up tools

#### 1. Install Apache

```bash
# On remote
sudo add-apt-repository ppa:ondrej/apache2
sudo apt update
# If firewall installed (skip if not)
sudo ufw allow “Apache Full”
# Enable firewall
sudo ufw enable
# Check Apache service status
sudo systemctl status apache2
```

If Apache service is active, you should now be able to access the public IPv4 of your instance and see the default Apache page:

{% include image.html file="/deploy/apache_page.png" alt="Default Apache page" caption="Default Apache page" %}

#### 2. Install PHP

PHP 7 comes by default in Ubuntu’s official repositories. Update and isntall Apache and some modules

```bash
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt install php libapache2-mod-php php-mbstring php-xmlrpc php-soap php-gd php-xml php-cli php-zip php-bcmath php-tokenizer php-json php-pear php-mysql zip unzip
```

To test that PHP (and also Apache) are working correctly, create a file in Apache's root durectory `/var/www/html`

```bash
sudo nano /var/www/html/test.php
```

and add

```php
<?php
phpinfo();
?>
```

Now, browse http://your_public_IPv4_address/test.php and you should see your server details.

#### 3. Configure DNS

For this step, you should allocate an elastic IP address for your EC2 instance use Route 53 to link your domain to that IP address. This is also important to avoid changing your instance's IP address every time it restarts.

First, allocate an elastic IP address for your EC2 instance:

{% include image.html file="/deploy/allocate_ip_address.png" alt="Allocate Elastic IP" caption="Allocate Elastic IP" %}

Then, register a hosted zone and a new record in Route 53 pointing to your domain name of type **A** (and an extra one as alias - `www.your_domain`). Route traffic to the elastic IP address of your EC2 instance.

Do the same for the API subdomain. Register a new record named `api.your_domain` pointing to the same IP address of your EC2 instance.

This [tutorial](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/migrate-dns-domain-in-use.html "Route 53 tutorial - AWS docs") might come in handy.

#### 4. Enable Apache modules

Add the following Apache modules for proxying, rewrite rules and headers:

```bash
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_http2
sudo a2enmod proxy_balancer
sudo a2enmod rewrite
sudo a2enmod headers
```

You should also disable `mpm_prefork` and enable `mpm_event` for **HTTP/2** support, along with `php7.4-fpm`:

```bash
# Enabling php7.4-fpm
sudo apt install php7.4-fpm
sudo a2dismod php7.4
sudo a2enconf php7.4-fpm
sudo a2enmod proxy_fcgi

# Enabling mpm_event
sudo a2dismod mpm_prefork
sudo a2enmod mpm_event
```

You may now reload Apache to enable such modules:

```bash
sudo systemctl reload apache2.service
```

#### 5. Add basic Apache configuration

Create a folder for the project (under `/var/www/<your domain name>`), copy your files to that folder and add a `.conf` file to `/etc/apache2/sites-available/` (e.g. `<your domain name>.conf`).

Write the following configuration to your `.conf` file:

```xml
<VirtualHost *:80>
    ServerName your_domain
    ServerAlias www.your_domain
    ServerAdmin webmaster@localhost
    Protocols h2 http/1.1
    DocumentRoot /var/www/your_domain/Admin_Portal
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
<VirtualHost *:80>
    ServerName api.your_domain
    Protocols h2 http/1.1
    ProxyPreserveHost On
    ProxyRequests Off
    ProxyErrorOverride Off
    ProxyPass / https://127.0.0.1:5001/
    ProxyPassReverse / https://127.0.0.1:5001/
    DocumentRoot /var/www/your_domain/Backend/API
</VirtualHost>
```

After that, you should now disable the default Apache website (as configured in the `000-default.conf` file) and enable your project website:

```bash
sudo a2dissite 000-default.conf
sudo a2ensite your_domain.conf
sudo systemctl restart apache2.service
```

#### 6. Install and set up RDBMS (MariaDB)

```bash
sudo apt install mariadb-server
sudo mysql_secure_installation
```

then

```
Remove anonymous users? [Y/n] y
Disallow root login remotely? [Y/n] n
Remove test database and access to it? [Y/n] y
Reload privilege tables now? [Y/n] y
```

You may now create the database of the project (and its user) by running the command:

```bash
sudo mariadb < /var/www/your_domain/Backend/Database/database_v2.1.sql
```

#### 7. Generate SSL certificate and update API settings

Now that your website has been enabled, you may now generate an SSL certificate for HTTPS.

First, follow the instructions described here to install `certbot`:

https://certbot.eff.org/lets-encrypt/ubuntufocal-apache

When asked, input your domain name to link the certificate. Certbot will automatically add the necessary configuration to your `domain_name.conf` file.

Since the API also uses this certificate, you will have to generate a `.pfx` file and add it to the `API` folder.

Run the command below to generate a `certificate.pfx` file from your certificate files:

```bash
sudo openssl pkcs12 -export -out certificate.pfx -inkey /etc/letsencrypt/live/your_domain/privkey.pem -in /etc/letsencrypt/live/your_domain/fullchain.pem
```

You will be asked to set a password for this certificate. Save it for later.

Move the `certificate.pfx` file to the `API` folder:

```bash
sudo cp certificate.pfx /var/www/your_domain/Backend/API/
```

And then update your `appsettings.Production.json` from the `API` folder:

```json
{
  "AppSettings": {
    "Secret": "your_api_secret",
    "CertificateFilename": "certificate.pfx",
    "CertificatePWD": "your_certificate_password",
    "Pepper": "your_pepper"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Warning",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Warning",
      "AdminApi.Services": "Information"
    }
  },
  "Debug": {
    "LogLevel": {
      "Default": "Warning",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Warning",
      "AdminApi.Services": "Information"
    }
  },
  "EventSource": {
    "LogLevel": {
      "Default": "Warning",
      "Microsoft": "Warning",
      "Microsoft.Hosting.Lifetime": "Warning",
      "AdminApi.Services": "Information"
    }
  },
  "Console": {
    "LogLevel": {
      "Default": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "StyleMeDevDB": "your_db_connection_string"
  },
  "Kestrel": {
   "EndPoints": {
     "Http": {
       "Url": "http://*:5050"
     },
     "Https": {
     "Url": "https://*:5051",
     "Certificate": {
       "Path": "certificate.pfx",
       "Password": "your_certificate_password"
     }
   }
 }
}
```

#### 8. Install .NET Core

Run the following commands to add the Microsoft package signing key to your list of trusted keys and add the package repository.

```bash
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
```

To install .NET Core SDK (3.1), run the following commands:

```bash
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-3.1
```

#### 9. Test API

Run the command below to build and run the API, ensure that it is working:

```bash
cd /var/www/your_domain/Backend/API
sudo dotnet watch run
```

If you run into issues related to settings secrets, add the same `AppSettings` and connection string from `appsettings.Production.json` to your user secrets:

```bash
sudo dotnet user-secrets init
sudo dotnet user-secrets set "Secret" "your_api_secret"
sudo dotnet user-secrets set "CertificateFilename" "certificate.pfx"
sudo dotnet user-secrets set "CertificatePWD" "your_certificate_password"
sudo dotnet user-secrets set "Pepper" "your_pepper"
sudo dotnet user-secrets set "ConnectionStrings.HairdressingProjectDB" "your_connection_string"
```

#### 10. Install NodeJS and npm

Moving on to the Admin Portal, install the necessary dependencies first:

```bash
sudo apt install nodejs
sudo apt install npm
```

#### 11. Install packages for the Admin Portal

Then, install packages:

```bash
cd /var/www/your_domain/Admin_Portal
sudo npm i
```

You can now build the Admin Portal (bundling all CSS, images, javascript and PHP files) by running the command:

```bash
sudo npm run build
```

#### 12. Update Apache configuration

Now that you have set up the database, SSL certificate, API and Admin Portal, you should update your Apache `.conf` file for production (NOT the original `your_domain.conf` file that you created previously, use the `your_domain-le-ssl.conf` file that was generated by `certbot` instead).

The new `.conf` file can be found at: `/etc/apache2/sites-available/your_domain-le-ssl.conf`

```xml
<IfModule mod_ssl.c>
<VirtualHost *:443>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com
	ServerName your_domain

	Protocols h2 http/1.1
	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/your_domain/your_domain/Admin_Portal

#	Rewrites
	<Directory />
		DirectoryIndex sign_in.php sign_in.html
	</Directory>

#	Permissions
	<Directory "/var/www/your_domain/Admin_Portal/classes">
		Order deny,allow
		Deny from all
	</Directory>

	<Directory "/var/www/your_domain/Admin_Portal/helpers">
		Order deny,allow
		Deny from all
	</Directory>


	<Directory "/var/www/your_domain/Admin_Portal/php_backup">
		Order deny,allow
		Deny from all
	</Directory>

	<Directory "/var/www/your_domain/Admin_Portal/webpack*">
		Order deny,allow
		Deny from all
	</Directory>

	<Directory "/var/www/your_domain/Admin_Portal/*.json">
		Order deny,allow
		Deny from all
	</Directory>

	<Directory "/var/www/your_domain/Admin_Portal/.gitignore">
		Order deny,allow
		Deny from all
	</Directory>

	<Directory "/var/www/your_domain/Admin_Portal/README*">
		Order deny,allow
		Deny from all
	</Directory>

	<Directory "/var/www/your_domain/Admin_Portal/node_modules">
		Order deny,allow
		Deny from all
	</Directory>

	SSLEngine on

#	Headers
	Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains"
	Header always set X-XSS-Protection "1; mode=block"
	Header always set X-Frame-Options "SAMEORIGIN"
	Header always set Expect-CT "max-age=604800, enforce, report-uri=https://your_domain/reports"
	Header always set X-Content-Type-Options "nosniff"
	Header always set Feature-Policy "autoplay 'none'; camera 'none'"
	Header always set Cache-Control "public, max-age=604800, immutable"
	Header unset X-Powered-By
	Header unset Pragma

#	Policies
	Header always set Content-Security-Policy "default-src 'unsafe-inline' https://your_domain https://api.your_domain.best https://cdnjs.cloudflare.com https://fonts.googleapis.com https://fonts.gstatic.com https://www.google.com https://www.gstatic.com;"

#	Caching
	ExpiresActive On
	ExpiresDefault "access plus 1 month"

	CacheRoot "/var/cache/apache2/"
	CacheEnable disk /
	CacheIgnoreCacheControl on
	CacheDirLevels 3
	CacheDirLength 5
	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf


SSLCertificateFile /etc/letsencrypt/live/your_domain/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/your_domain/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
</IfModule>
<IfModule mod_ssl.c>
<VirtualHost *:443>
	ServerName api.your_domain.best
	Protocols h2 http/1.1
	ProxyPreserveHost On
	ProxyRequests Off
	ProxyErrorOverride Off
	ProxyPass / https://127.0.0.1:5001/
	ProxyPassReverse / https://127.0.0.1:5001/
	DocumentRoot /var/www/your_domain/Backend/API

SSLProxyEngine on
SSLCertificateFile /etc/letsencrypt/live/your_domain/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/your_domain/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
</VirtualHost>
</IfModule>
```

After modifying and saving your `your_domain-le-ssl.conf` file, reload Apache:

```bash
sudo systemctl reload apache2.service
```

#### 13. Test the Admin Portal

You should now be able to navigate to https://your_domain and be greeted with the Sign In page of the Admin Portal.

## Using Docker + Nginx

If you are using our Docker images with Nginx, write the following configurations:

- Nginx global configuration (`/etc/nginx/nginx.conf`):

```
http {
	...
	log_format compression '$remote_addr - $remote_user [$time_local] '
							'"$request" $status $body_bytes_sent '
							'"$http_referer" "$http_user_agent" "gzip_ratio"';
	...
}
```

- Users API + Pictures API (`/etc/nginx/sites-available/api.styleme.best`):

```
server {
  server_name api.styleme.best;
  access_log /var/log/nginx/api.styleme.access.log compression;

  root /home/styleme/styleme/Backend;

  keepalive_timeout 30;

  location ~* ^\/(users|colours|hair_styles|face_shapes|hair_lengths) {
    proxy_pass                  http://localhost:5050;
    proxy_set_header            Host $host;
    proxy_set_header            X-Real-IP $remote_addr;
  }

  location ~* \/(pictures|history|models) {
    proxy_pass                  http://127.0.0.1:8000;
    proxy_set_header            Host $host;
    proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header            X-Forwarded-Proto $scheme;
    proxy_set_header            Connection keep-alive;
    proxy_redirect              off;
    proxy_buffering             off;
  }

    listen [::]:443 ssl ipv6only=on http2; # managed by Certbot
    listen 443 ssl http2; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/api.styleme.best/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/api.styleme.best/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = api.styleme.best) {
        return 301 https://$host$request_uri;
   } # managed by Certbot


  listen 80 deferred;
  listen [::]:80 deferred;
  client_max_body_size 4G;

  server_name api.styleme.best;
  keepalive_timeout 30;

    return 404; # managed by Certbot
}
```

- Admin Portal / Adminer (`/etc/nginx/sites-available/admin.styleme.best`):

```
server {
  root ~/styleme/Backend;

  server_name admin.styleme.best www.admin.styleme.best;

  location / {
          proxy_pass              http://localhost:8080;
          proxy_set_header        Host $host;
  }


  listen [::]:443 ssl http2; # managed by Certbot
  listen 443 ssl http2; # managed by Certbot
  ssl_certificate /etc/letsencrypt/live/admin.styleme.best/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/admin.styleme.best/privkey.pem; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
  if ($host = www.admin.styleme.best) {
      return 301 https://$host$request_uri;
  } # managed by Certbot


  if ($host = admin.styleme.best) {
      return 301 https://$host$request_uri;
  } # managed by Certbot


      listen 80;
      listen [::]:80;

      server_name admin.styleme.best www.admin.styleme.best;
  return 404; # managed by Certbot
}
```

Refer to [this link](https://github.com/HairdressingProject/styleme/blob/deploy/Backend/README.md#simulating-a-production-environment "Simulating a production environment") for instructions on how to add the certificate to the Users API configuration.
