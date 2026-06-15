# USER_DOC

The docker-compose.yaml file is a configuration file that helps to orchestrate
different services isolated in separated containers.

Each one of those services has their own dockerfile to build their own image.
___

## Nginx:

- This is the reverse proxy that stands between the server and the client.
- It assures a secured connexion (https, TLS1.2 TLS1.3)
- It routes requests to the good services.

## Wordpress:

- Is the content of the website, it allows to create users and manages the website with an interface. It allows to upload files and download plugins

## Mariadb:

- is the database of wordpress. It stores:
    - Wordpress credentials
    - Articles
    - Commentaries
    - Every dynamic data for the website (except voluminous files like uploaded files/media)
___

## How to build the project:

In Inception directory use:

```bash
make all # build the project
make fclean # clean the project
make re # rebuild
make stop # stop the containers without destroying containers
```
___

## Access the website and the administration panel.

- Access the website in the browser with: https://jwuille.42.fr
- or the administration panel with https://jwuille.42.fr/wp-login.php then connect with admin credentials

## Locate and manage credentials.

- Password are stored in txt files in secrets directory
- Identifiers, domain name and mails are in srcs/.env
- Everything can be changed in those files

## Check that the services are running correctly.

- Check if the services are running with make ps
