FROM debian:12

RUN apt-get update && apt-get install -y lighttpd \
	&& rm -rf /var/lib/apt/lists/*

RUN useradd -r -s /sbin/nologin lighttpd

COPY conf/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY conf/static_page.html /var/www/html/index.html

EXPOSE 80

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
