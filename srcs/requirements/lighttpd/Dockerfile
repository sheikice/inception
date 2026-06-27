FROM debian:12

RUN set -e && apt-get update && apt-get install -y --no-install-recommends lighttpd \
	&& rm -rf /var/lib/apt/lists/*

RUN useradd -r -s /sbin/nologin lighttpd

COPY conf/lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY conf/static_page.html /var/www/html/static/index.html

EXPOSE 80

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
