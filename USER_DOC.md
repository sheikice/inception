# USER_DOC

## How to check services of the project:

In Inception directory use:

```bash
make ps
```

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

### Website

- Access the website in the browser with:

```bash
firefox https://jwuille.42.fr # use the browser of your choice and write the domain name written in srcs/.env
```

- Access the static website in the browser with:

```bash
firefox https://jwuille.42.fr/static # use the browser of your choice and write the domain name written in srcs/.env
```

### Wordpress admin

- access the administration panel with: 

```bash
https://jwuille.42.fr/wp-login.php # then connect with admin credentials from secrets and srcs/.env
```

### Adminer admin

- access the administration panel for the database with:

```bash
https://jwuille.42.fr/myadminer.php # then connect with user mysql credentials from secrets and srcs/.env
# Server mariadb:3306
# Username  *written in srcs/.env*
# Password  *written in secrets*
# Database wordpress
```

## Use FTP


```bash
ftp localhost 21 # Connect to the ftp server with credentials in *srcs/.env* and secrets
help # list all ftp commands
send <file># upload file to server directory
ls # list files in upload directory
get <file># download file to server directory
```

## Locate and manage credentials.

- Identifiers, domain name and mails are in srcs/.env
- Password are stored in txt files in secrets directory
- Creds can be changed in those 2 files
