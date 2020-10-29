# Hairdressing Project - Backend

To start a development environment for the backend using `docker-compose`, run from this folder:

```bash
docker-compose up
```

If you wish to run the previous command in the background, simply add a `-d` flag:

```bash
docker-compose up -d
```

The `docker-compose.yml` file includes (for the time being):

- MariaDB with user and database configured
- Adminer
- ASP.NET Core API
