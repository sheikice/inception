FROM debian:12

RUN set -e && apt-get update && apt-get install -y --no-install-recommends \
	php8.2-fpm \
	php8.2-redis \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    wget \
	netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/setup_wp.sh /usr/local/bin/setup_wp.sh

RUN chmod +x /usr/local/bin/setup_wp.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["setup_wp.sh"]

CMD ["php-fpm8.2", "-F"]


