*This project has been created as part of the 42 curriculum by jwuille.*

# DESCRIPTION
___

## What is Inception?

This 42 project is about creating a simple docker architecture
that includes wordpress, nginx and mariaDb. 
Nginx is the service that assures a secured HTTPS connexion between the server and the client. It also routes the client request to the appropriate service.
It's possible to manage the site web and install plugins via wordpress.
Almost all its content is stored in mariadb database.

## Goal

This architecture is built with a config file docker-compose.yml that setup correctly the containers, the volumes (for persistent data like the database content) and the network for containers communication.
The only official image used in this project is debian:12, the others are self-made with their dedicated Dockerfile.
I choose debian bookworm for simplicity over alpine which is lighter but less documented.
Please read the USER_DOC.md for more informations on how to build the project.
There is also a DEV_DOC.md for more details on the setup.

## Key concepts

### Virtual Machines vs Docker

Docker creates an isolated light weigthed environment that runs services inside and brings their own dependancies.
	A container is lighter than a virtual machine and faster to deploy
	- it uses linux kernel to run containers so it makes it fast to run
	- it's easy to give the environment configuration so anyone can have the same environment working on the same project
	- it reinforces the security as we can expose juste one entrypoint (nginx) and each container can communicate with each other using their docker network
	- if a container crash, it can restart and doesnt impact the other containers/services
	- its possible to update a service/environment without impacting other services/containers

### Secrets vs Environment Variables

There is a .gitignore file that prevent secrets and .env to appear in the git.
	In a first place, its possible to use env-file directive to add environment variables in containers. Thoses variables are easy to find in containers with `docker inspect 'container name'`
	Docker compose has secrets directive to use local data that shouldnt be shared or uploaded. This way its not possible to see the passwords with docker inspect.
	
### Docker Network
The docker network is used to allow communication between each containers.
Nginx is the only one exposed on port 443 (common port for HTTPS).
Then it has to routes to fast_cgi on port 9000 of wordpress container(php-fpm).
If wordpress needs to call the database it will make a request to port 3306 of mariadb container

### Docker Volumes

Named volumes are used to create persistent data. Even after a `make fclean`. Its stored in the device path that is configured in .env file
	Mariadb has its own volume to store all the wordpress content and data.
	Wordpress has also its own volume to store heavy files like uploaded images.

# Instructions
___

### Install for DEBIAN:
```bash
	sudo apt-get update && apt-get install -y make curl # Requirements

	curl -fsSL https://download.docker.com/linux/debian/gpg \
    | gpg --dearmor -o /usr/share/keyrings/docker.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list # Docker repo setup

	sudo apt-get update && apt-get install -y docker docker-compose-plugin # Docker Requirements
	cp srcs/.env.example srcs/.env # you can fill this file too or let it just like the example (simpler)
	sudo sed -i "s/DOMAIN_NAME=jwuille/DOMAIN_NAME=${USERNAME}/" srcs/.env
	sudo sed -i "s/localhost/localhost ${USERNAME}.42.fr/" /etc/hosts # Must be adapted to domain name in .env file

	make # Build the project
	firefox "https://${USERNAME}.42.fr" # replace login.42.fr with the domain name in .env
	# it may end in 502 Gateway, that means the website is still configurating, reload the page in 2 minutes	
```

### Clean the project:
```bash
	make fclean
	cd ~/data && sudo rm -rf mariadb wordpress # if you want to DEFINITELY delete and lose the persistent data (!WARNING)
```

# Resources
___
- official dockerfile doc: https://docs.docker.com/reference/dockerfile/
- official docker compose doc: https://docs.docker.com/compose/
- official nginx doc: https://nginx.org/en/docs/
- official mariadb doc: https://mariadb.com/docs
- official wordpress doc: https://wordpress.org/documentation/
- official fpm-php doc: https://www.php.net/manual/en/install.fpm.php
- Article about docker secrets: https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/secrets/
- Article about generating a self signed certificate for https connexion: https://medium.com/@yakuphanbilgic3/create-self-signed-certificates-and-keys-with-openssl-4064f9165ea3
- IA (mostly Claude Sonnet 4.6) was used as a mentor. Setup with a master prompt for acting as a Socratic tutor helping to learn the key concepts behind the 42 Inception project.
