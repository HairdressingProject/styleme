![Flutter CI](https://github.com/HairdressingProject/styleme/workflows/Flutter%20CI/badge.svg?branch=master)
![License](https://img.shields.io/github/license/HairdressingProject/styleme)
![Issues](https://img.shields.io/github/issues/HairdressingProject/styleme)
![PRs](https://img.shields.io/github/issues-pr/HairdressingProject/styleme)
![Commit activity](https://img.shields.io/github/commit-activity/w/HairdressingProject/styleme)

# Hairdressing Project - Style Me App

Building upon the previously built database, API and Admin Portal of our project, this repository will contain the previous three components plus the documentation, design (mockups, wireframes, etc.) and implementation required for the Style Me App. 

## Getting started
If you just want to play around with the app, you may simply install the latest Android `apk` available [here](https://github.com/HairdressingProject/styleme/tags "Release tags").

> NOTE: The `apk` built for release connects to our backend hosted on an EC2 instance, which may not be running. Contact the developers if you wish to test the app.

### Project structure

This project consists of two main components and a few subcomponents:

- Backend
  - [Users API](https://github.com/HairdressingProject/styleme/tree/master/Backend/UsersAPI) (ASP.NET Core)
  - [Pictures API](https://github.com/HairdressingProject/styleme/tree/master/Backend/PicturesAPI) (FastAPI)
  - [Database](https://github.com/HairdressingProject/styleme/tree/master/Backend/Database) (MariaDB)
  - Adminer

- Frontend
  - [StyleMe app](https://github.com/HairdressingProject/styleme/tree/master/app) (Flutter)
  - [Admin Portal](https://github.com/HairdressingProject/styleme/tree/master/Admin_Portal) (PHP, currently outdated)

### Setting up a development environment
We are using Docker for convenience, both in development and production. We recommend using a Unix-based OS for development, although Windows also works fine.

The [`docker-compose.yml`](https://github.com/HairdressingProject/styleme/blob/master/Backend/docker-compose.yml "Docker compose") file builds images required for development, with the following services:

- __db__: The main database of this project
- __adminer__: A PHP-powered database management portal that connects to __db__
- __prometheus__: A monitoring system to profile the Pictures API that continuously outputs metrics
- __grafana__: A dashboard / data visualisation tool that connects to __prometheus__
- __users_api__: An ASP.NET Core API that mainly deals with user accounts, authentication, authorisation and exposes CRUD actions for various categories related to the features seen in the app, such as face shapes, hair styles and hair colours.

To start all of those services and leave them running in the background, move to the Backend directory and run:

`docker-compose up -d`

You should now build the [Pictures API](https://github.com/HairdressingProject/styleme/tree/master/Backend/PicturesAPI "Pictures API") as instructed [here](https://github.com/HairdressingProject/styleme/blob/master/Backend/PicturesAPI/README.md "Building the Pictures API"). It requires [Python](https://www.python.org/ "Python") >= 3.8.5 and [Anaconda](https://www.anaconda.com/products/individual "Anaconda").

## Links
- [Live documentation](https://hairdressingproject.github.io/styleme/ "Documentation")
- [Trello](https://trello.com/b/oVGT3m0P "Trello board")
- [Asana](https://app.asana.com/0/1187175073096657/board "Asana board")
- [Admin Portal](https://styleme.best "Admin Portal")
