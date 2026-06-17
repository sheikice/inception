FROM debian:12

RUN set -e && apt-get update && apt-get install -y \
	php8.2-fpm \
	php8.2-redis \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip \
    wget \
    curl \
	default-mysql-client \
	sendmail \
	netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/setup_wp.sh /usr/local/bin/setup_wp.sh

RUN chmod +x /usr/local/bin/setup_wp.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["setup_wp.sh"]
