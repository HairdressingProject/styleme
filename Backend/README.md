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

2. **Start services**

   Now run the command below from the `Backend` folder to start all services:

   ```bash
    $ docker-compose -f docker-compose.production.yml
   ```

   As mentioned previously, you may add the `-d` flag to the previous command to let it run in the background.

   Notice in the logs that the Users API will now use production settings, which you may customise / fine tune by modifying the `appsettings.Production.json` file.

   Refer to the [docs](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/servers/kestrel?view=aspnetcore-3.1 "Kestrel configuration") for more information.

   **NOTE**: Although the logs mention that the Users API will also be listening on `https://localhost:5051`, it will not work because no SSL certificate was configured in the container. You should use `http://localhost:5050` instead.

The `docker-compose.yml` file includes the following services (for the time being):

- MariaDB with user and database configured (`db`)
- Adminer (`adminer`)
- ASP.NET Core API (`users_api`)
- FastAPI and ML dependencies (`pictures_api`)
