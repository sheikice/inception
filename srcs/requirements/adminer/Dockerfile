FROM debian:12

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
	wget \
	php8.2-fpm \
    php8.2-mysql \
	&& wget -O myadminer.php https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php \
	&& rm -rf /var/lib/apt/lists/*

RUN useradd -r -s /sbin/nologin adminer

RUN chown adminer:adminer /var/www/html

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

EXPOSE 8080

CMD ["php-fpm8.2", "-F"]
