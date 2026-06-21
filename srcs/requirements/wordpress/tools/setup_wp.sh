#!/bin/bash
set -e

WP_PATH="/var/www/html"
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/mysql_password)

WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

# Download wp-cli
if [ ! -f /usr/local/bin/wp ]; then
    wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -O /usr/local/bin/wp
    chmod +x /usr/local/bin/wp
fi

# Install WordPress
if [ ! -f "${WP_PATH}/wp-config.php" ]; then

    # Download core WordPress
    wp core download --path="${WP_PATH}" --allow-root --quiet

    # Create wp-config.php from .env vars
    wp config create --path="${WP_PATH}" --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb:3306" --allow-root --quiet

    # wait for MariaDB available
    until wp db check --path="${WP_PATH}" --allow-root --quiet 2>/dev/null; do
        echo "Waiting for MariaDB..."
        sleep 2
    done


	# wait for redis available
    until nc -z redis 6379 2>/dev/null; do
        echo "Waiting for redis..."
        sleep 2
    done

    # Install WordPress
    wp core install --path="${WP_PATH}" --url="https://${DOMAIN_NAME}" \
        --title="Inception" --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" --allow-root --quiet

    # Create user
	if ! wp user get "${WP_USER}" --path="${WP_PATH}" --allow-root --quiet 2>/dev/null; then
		wp user create "${WP_USER}" "${WP_USER_EMAIL}" --role=author \
			--user_pass="${WP_USER_PASSWORD}" --path="${WP_PATH}" \
			--allow-root --quiet
	fi
	
	# redis config
	wp plugin install redis-cache --activate --path="${WP_PATH}" --allow-root
	sed -i "s|/\* That's all, stop editing\! Happy publishing\. \*/|define( 'WP_REDIS_HOST', 'redis' );\ndefine( 'WP_REDIS_PORT', 6379 );\n\n/* That's all, stop editing! Happy publishing. */|" "${WP_PATH}/wp-config.php"
	wp redis enable --path="${WP_PATH}" --allow-root

	# useless theme
	# wp theme install saaslauncher --activate --path="${WP_PATH}" --allow-root --quiet
	echo "All essential plugins installed and activated!"

    chown -R www-data:www-data "${WP_PATH}"
fi

rm -rf /var/log/php8.2-fpm.log \
	&& rm -rf /var/log/php-fpm-access.log \
	&& ln -s /dev/stderr /var/log/php8.2-fpm.log \
	&& ln -s /dev/stdout /var/log/php-fpm-access.log \
	&& touch /var/log/php8.2-fpm.log \
	&& touch /var/log/php-fpm-access.log


# php-fpm foreground — PID 1
PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
exec "$@"
