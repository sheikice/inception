#!/bin/bash
set -e


WP_UID=$(stat -c '%u' /var/www/html/wp-content)
WP_GID=$(stat -c '%g' /var/www/html/wp-content)
FTP_PASSWORD=$(cat /run/secrets/ftp_user_password)

# Init first boot
if ! grep -q pasv_address /etc/vsftpd.conf; then
	echo "/bin/false" >> /etc/shells
	echo "pasv_address=${DOMAIN_NAME}" >> /etc/vsftpd.conf
	useradd -o --uid=$WP_UID --gid=$WP_GID --no-create-home --home-dir /var/www/html/wp-content/uploads -s /bin/false -c 'ftp fg' "${FTP_USER}"
	echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
	mkdir -p /var/run/vsftpd/empty /var/ftp
	rm -rf /srv/ftp
	ln -s /dev/stdout /var/log/vsftpd.log
	touch /var/log/vsftpd.log
fi

exec  "$@"
