# learnguage-api

[![js-semistandard-style](https://img.shields.io/badge/code%20style-semistandard-brightgreen.svg?style=flat-square)](https://github.com/Flet/semistandard)

This repository contains the backend/REST API server of the Learnguage project.

# Running using Docker

Prerequisites: [Docker Engine](https://docs.docker.com/engine/installation/) and [Docker Compose](https://docs.docker.com/compose/install/) must be installed; Internet access for pulling NPM packages and Docker images.

Note: Docker commands might need root privileges/sudo.

1. Copy `config/default.json` to `config/local.json`, and edit its contents as necessary (e.g. add Firebase credentials, MongoDB connection details).
2. Run `docker-compose build`. Docker will download NPM packages (application dependencies).
3. Run `docker-compose up -d` to start the application and its supporting services (MongoDB) in the background. Docker will download images if necessary.

- To stop the containers, run `docker-compose stop`.
- To start the application again, simply run `docker-compose up` or `docker-compose up -d` to run in the background (if you don't need to recreate containers, you can also use `docker-compose start`).
- Use `docker ps` to list running containers.
- Use `docker exec -ti <container_name> /bin/sh` to get a shell on a running container.
- To remove the containers, run `docker-compose down`.
- If the `Dockerfile` or `docker.env` is modified, you will need to rebuild the Docker images by removing the containers and running `docker-compose build` again.
