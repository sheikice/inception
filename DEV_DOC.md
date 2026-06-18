# **DEV_DOC.md**

## Set up the environment from scratch (prerequisites, configuration files, secrets).
___

### requirements on linux:

[IMPORTANT]
cf requirements part of README.md

### configuration files:
- Every Dockerfiles
- mariadb config file: srcs/requirements/mariadb/conf/my.cnf
- wordpress config file: srcs/requirements/wordpress/conf/www.conf
- nginx config file: srcs/requirements/nginx/conf/nginx.conf

### secrets:

```bash
ls secrets # stores sensitive data like passwords
```
- secrets are created in /run/secrets in their dedicated containers
- check with `docker exec mariadb ls /run/secrets`
- check with `docker exec wordpress ls /run/secrets`

### environment:

```bash
cat srcs/.env # stores not sensitive data like domain name
```

### manage the project:

```bash
make all # build
make stop # stop the containers
make logs # show docker compose logs
make fclean # clean the project
make ps # show running containers
```

### Manage the containers and volumes:

```bash
make all # 1: build
docker exec -it mariadb bash # 2: launch shell in a container to examine it
docker inspect mariadb # 3: inspect the container

docker exec -it mariadb kill 1 # 4: force a crash in a container
docker inspect mariadb # 5: read restart count value
docker logs mariadb # 6: check container logs
docker volume ls # 7: list volumes of containers
docker volume inspect srcs_mariadb # 8: inspect specific volume + check where the data is stored on host 
```

docker compose manages volumes that are binded to a location (device path in .env file) that stores permanently the mariadb and wordpress data.
