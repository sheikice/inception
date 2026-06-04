#!/bin/bash
set -e

WP_PATH="/var/www/html"

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
        --dbhost="mydb:3306" --allow-root --quiet

    # wait for MariaDB available
    until wp db check --path="${WP_PATH}" --allow-root --quiet 2>/dev/null; do
        echo "Waiting for MariaDB..."
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

	## Install essential plugins
	PLUGINS=(
	"woocommerce"
	"elementor"
	"contact-form-7"
	"wpforms-lite"
	"seo-by-rank-math"
	"wp-super-cache"
	)

	for PLUGIN in "${PLUGINS[@]}"; do
	wp plugin  install $PLUGIN --activate --path="${WP_PATH}" --allow-root --quiet
	done

	echo "All essential plugins installed and activated!"
	# useless theme
	wp theme install saaslauncher --activate --path="${WP_PATH}" --allow-root --quiet

    chown -R www-data:www-data "${WP_PATH}"
fi

# php-fpm foreground — PID 1
PHP_VERSION=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
exec php-fpm${PHP_VERSION} -F
