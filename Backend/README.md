# Hairdressing Project - Backend

Before initialising your containers, update the `USERS_API_URL` variable in your `.env` file inside `PicturesAPI/app` with the following:

```bash
USERS_API_URL=http://22.22.22.4:5050
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

The `docker-compose.yml` file includes the following services (for the time being):

- MariaDB with user and database configured (`db`)
- Adminer (`adminer`)
- ASP.NET Core API (`users_api`)
- FastAPI and ML dependencies (`pictures_api`)
