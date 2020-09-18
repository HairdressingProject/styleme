---
title: Admin Portal Deployment
keywords: Admin portal, Api
last_updated: July 23, 2020
tags: [api]
summary: "This document outlines how to deploy the Admin Portal to a Digital Ocean Droplet."
sidebar: mydoc_sidebar
permalink: mydoc_admin_portal_deploy.html
folder: mydoc
---

## Table of contents
- [Cloud Service Provider](#Cloud-Service-Provider)
- [Features](#Features)
- [Development Stack </>](#Development-Stack)
- [Deployment](#Deployment)


## Cloud Service Provider
The chosen Cloud service product for this project is going to be a Digital Ocean Droplet (Virtual Private Server)

## Features:
+ OS: Ubuntu 18.04.03 (LTS) x64
+ CPU: 1 CPU - Single core
+ Memmory: 1 GB
+ Data Transfer: 1000 GB
+ Pricing: $5 per month / $0.007 per hour

## Development Stack
LAMPD - Linux / Apache / MariaDB / PHP / .NET Core

## Deployment
To successfuly deploy this web application, we require to follow several steps

### 1a. Create account, new project and droplet

Create an account on Digital Ocean and a new Droplet

### 1b. Create user and RSA key (optional)
Some steps on this section can be optional, but all of them are recommended.

So first thing is, we are going to connect to our remote server using ssh. Most OS already have SSH (or Open SSH) installed.

We are login as root with our password

From your desired terminal, start an ssh connection to the remote host as root

```bash
# On local machine
ssh root@178.128.94.81 # change ip with your droplet ipv4 address
```

We can generate a RSA key to log from our local terminal instead of using the password. This makes our environment more secure and we dont have to input the password, as we are going to be login with the key.

```bash
# On local machine
ssh-keygen -C "admin"
# By default generates a RSA key.
# -C is the comment flag (optional)
```
The new key should be stored as ```~/.ssh/id_rsa``` and ```~/.ssh/id_rsa.pub```

```bash
# On local machine
cat ~/.ssh/id_rsa.pub
#Output: (This is an example key)
ssh-rsa AAAAB3NzaC1yc2AAAADAQABAAABAQDB82tBkBZGXcNzMAxAI/t4UkKXyzg2HcGofDHyCI88MPqS1vt/2z8rXxr+T3/7rXXJ2KBp76JWfdasfsdf453FDSsdfsdfSDFAUctryC6mfas8F+zfKQnTpBdhwGaeZwegkRkpRjIoEYN3u+4aRfeU8uE1dYjwli9YR7kQXRfUpi/sdf4S45SDF8Roi2uwkaqOEnEr3Livc7x/TOuvb1jJJtUFGlWwBms9MBEdPS0XykTwldcY93F2TCzKnj6jZ admin

```

Now we have to create a new user on the remote machine named `administrator` and provide the user with sudo privileges

```bash
# On remote machine
adduser administrator
usermod -aG admin administrator
```

Now we need to change to the `administrator` and copy the generated public key
```bash
# On remote machine
su administrator
cd

mkdir .ssh
cd ~/.ssh
nano authorized_keys
```

On that directory, there should be a file named `authorized_keys`. If not, we can create it. Then open it with `nano` or `vim`and then paste the public RSA key.



From now on, everyime we are going to login as administrator, not as root.
Optional step is to remove root user's login rights.
```bash
# On remote
sudo nano /etc/ssh/sshd_config   # or sudo vim /etc/ssh/sshd_config
```

set `PermitRootLogin no`, `PasswordAuthentication no`. Then
```bash
# On remote
sudo service ssh restart
exit
```

Now the user should be able to login as administrator using the public key:
```bash
# On local
ssh -i ~/.ssh/id_rsa administrator@178.128.94.81
```

Note: It is strongly advised to remove root acces to the remote server.





### 2. Install tools
#### 1. Install Apache
```bash
# On remote
sudo apt update
sudo apt install apache2
# If firewall installed (skip if not)
sudo ufw allow “Apache Full”
# Check Apache service status
sudo systemctl status apache2
```

If Apache service is active, we can broswe http://178.128.94.81/ and verify if the default apache page is showing.

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

Now, browse http://178.128.94.81/test.php and you should see this screen:

Note that the current PHP version is 7.2. We will upgrate later.


#### 3. Install Database Manager (MariaDB)
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

#### 4. Install Comnposer
First, download Composer
```bash
curl -sS https://getcomposer.org/installer | php
```

To make Composer avaibable globally and make it executable
```bash
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
```

#### 5. Install .NET Core
Run the following commands to add the Microsoft package signing key to your list of trusted keys and add the package repository.

```bash
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
```

To install .NET Core SDK, run the following commands:

```bash
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-3.1
```



#### 5.a Configure Virtual Memory (Swap File) 
We can check if our machine already has swap memory allocated by running
```bash
free
```

Virtual memory allows your system (and thus your apps) additional virtual RAM beyond what your system physically has - or in the case of droplets, what is allocated. It does this by using your disk for the extra, 'virtual' memory and swaps data in and out of system memory and virtual memory as it's needed.

Lets cd to /var and create the swap memory file
```bash
cd /var
touch swap.img
chmod 600 swap.img
```
Now we have to size our `swap.img` file. A general rule of thumb is to have a swap memory size between 1 and 2 times our RAM memory, so in this case, as we have 1GB of RAM memory, we are going to give a size of 2GB of swap

```bash
sudo dd if=/dev/zero of=/var/swap.img bs=2048k count=1000
```
```
# Output:
[sudo] password for administrator:
1000+0 records in
1000+0 records out
2097152000 bytes (2.1 GB, 2.0 GiB) copied, 5.20101 s, 403 MB/s
```

Now we can initialize the swap file system
```bash
sudo mkswap /var/swap.img
```
```
Setting up swapspace version 1, size = 2 GiB (2097147904 bytes)
no label, UUID=d3c48e54-78be-4095-81d0-f63a79f995a9
```
Now we can enable the Swap file and check with `free`
```bash
swapon /var/swap.img
free
```
```
# Output:
              total        used        free      shared  buff/cache   available
Mem:        1009176      160096       76984        2188      772096      695972
Swap:       2047996           0     2047996
```

Add Composer's vendor bin directory to our `$PATH` in order to make it executable:

```bash
echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
source ~/.bashrc
```
Let's install PHP7.4
```bash
sudo apt install php7.4 php7.4-mbstring php7.4-xmlrpc php7.4-soap php7.4-gd php7.4-xml php7.4-cli php7.4-zip php7.4-bcmath php7.4-tokenizer php7.4-json

php -v
# Output:
PHP 7.4.7 (cli) (built: Jun 12 2020 07:44:05) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
    with Zend OPcache v7.4.7, Copyright (c), by Zend Technologies
```

Also, we have to configure Apache to use PHP 7.4 (it was using version 7.2)
```bash
sudo a2dismod php7.2
sudo a2enmod php7.4
systemctl restart apache2
```


#### Install NVM (NodeJS and npm)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm ls-remote
nvm install 12.18.1
nvm use 12.18.1
node -v
npm -v
```




### 3. Permissions (ToDo: check correct permissions)

Set some permissions
```bash
sudo chown -R administrator:www-data /var/www/
sudo chown -R administrator:www-data /var/www/GGG-SomeApp
chmod -R 750 /var/www/GGG-SomeApp
chmod -R 770 /var/www/GGG-SomeApp
```




### 5. Start Apache web server
First, we need to copy the apache default configuration and rename it:
```bash
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/GGG-SomeApp.conf
```
Edit the new configuration
```bash
sudo nano /etc/apache2/sites-available/GGG-SomeApp.conf
```
we have to add or edit this lines:
```
ServerAdmin administrator@localhost
DocumentRoot /var/www/GGG-SomeApp/public
<Directory /var/www/GGG-SomeApp/>
    AllowOverride All
</Directory>
```

Now, we have to tell Apache to stop using the default configuration and use the one we just created, enable mod_rewrite and restart apache

```bash
sudo a2dissite 000-default.conf
sudo a2ensite GGG-SomeApp
sudo a2enmod rewrite
systemctl restart apache2
```







