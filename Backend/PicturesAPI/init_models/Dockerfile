FROM python:3.9-slim-buster

ARG workdir=/init_models

WORKDIR ${workdir}

RUN pip install requests

COPY . .
