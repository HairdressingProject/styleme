# Hairdressing Project - Backend

Before initialising your containers, update the `USERS_API_URL` variable in your `.env` file inside `PicturesAPI/app` with the following:

```bash
USERS_API_URL=http://22.22.22.4:5050
```

You should update the `DB_HOST` variable in the same file as well:

```bash
DB_HOST=db
```

To start a development environment for the backend using `docker-compose`, run from this folder:

```bash
docker-compose up
```

If you wish to run the previous command in the background, simply add a `-d` flag:

```bash
docker-compose up -d
```

If you are running it for the first time, it will take a while (around 10-20 minutes) to install all dependencies needed. You will have to wait until both APIs have started running, which can be verified by reading the logs from the `Backend` folder (you will need to do this if you ran `docker compose up -d` instead of `docker-compose up`):

```bash
docker-compose logs
```

Pass the `-f` flag to leave it running:

```bash
docker-compose logs -f
```

To stop your services, run:

```bash
docker-compose down
```

## Simulating a production environment

If you wish to test production settings and other scenarios, follow the steps below:

1. **Add production settings for Users API**

   Create a file called `appsettings.Production.json` inside the `UsersAPI` folder, identical to `appsettings.json` (simply copy and paste the code).

   Then, add the following section at the end of `appsettings.Production.json` (after `ConnectionStrings`):

   ```json
    "ConnectionStrings": {"..."},
    "Kestrel": {
      "EndPoints": {
        "Http": {
          "Url": "http://*:5050"
        },
        "HttpsDefaultCert": {
          "Url": "https://*:5051"
       }
     }
    }
   ```

   If you already have an SSL certificate, then use the configuration below instead:

   ```json
   "ConnectionStrings": {"..."},
    "Kestrel": {
      "EndPoints": {
        "Http": {
          "Url": "http://*:5050"
        },
        "Https": {
        "Url": "https://*:5051",
        "Certificate": {
          "Path": "certificate.pfx",
          "Password": "<your certificate password>"
        }
      }
    }
   }
   ```

Refer to [our documentation](https://hairdressingproject.github.io/styleme/mydoc_admin_portal_deploy_aws.html#7-generate-ssl-certificate-and-update-api-settings "Generate SSL certificate") for more information on how to generate a `certificate.pfx` file.

You may also check out [this link](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04 "Securing Nginx with Let's Encrypt") for instructions on how to create a Let's Encrypt SSL certificate and link it to your Nginx configuration using [certbot](https://certbot.eff.org/ "Certbot").

2. **Start services**

   Now run the command below from the `Backend` folder to start all services:

   ```bash
    $ docker-compose -f docker-compose.production.yml up
   ```

   As mentioned previously, you may add the `-d` flag to the previous command to let it run in the background.

   Notice in the logs that the Users API will now use production settings, which you may customise / fine tune by modifying the `appsettings.Production.json` file.

   Refer to the [docs](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel?view=aspnetcore-3.1 "Kestrel configuration") for more information.

   **NOTE**: Although the logs mention that the Users API will also be listening on `https://localhost:5051`, it will not work because no SSL certificate was configured in the container. You should use `http://localhost:5050` instead.
   
 3. **Start Pictures API**
   
   Using [gunicorn](https://gunicorn.org/ "Gunicorn website") is recommended to run FastAPI applications in production. 
   
   Run this command to start it from the `PicturesAPI` folder (instead of the usual `uvicorn app.main:app --reload`):

   ```bash
   gunicorn -w 4 -k uvicorn.workers.UvicornWorker --bind="0.0.0.0:8000" app.main:app
   ```
   
   You may adjust the `-w` option (number of workers) as needed. Refer to the [docs](https://docs.gunicorn.org/en/latest/design.html?highlight=workers#how-many-workers "How many workers?") for more information on this.
   
The `docker-compose.yml` file includes the following services (for the time being):

- MariaDB with user and database configured (`db`)
- Adminer (`adminer`)
- ASP.NET Core API (`users_api`)
- FastAPI and ML dependencies (`pictures_api`)
