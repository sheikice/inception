FROM debian:12

RUN apt-get update && apt-get install -y --no-install-recommends \
	nginx \
	openssl \
	procps \
	perl \
	curl \
	&& rm -rf /var/lib/apt/lists/* \
	&& openssl req -x509 -nodes -days 365 \
	-newkey rsa:4096 -keyout /etc/ssl/private/mykey.key -out /etc/ssl/certs/mycf.crt \
	-subj "/C=FR/ST=France/L=Paris/CN=jwuille.42.fr/emailAddress=bar@foo.fr" \
	-addext "subjectAltName=DNS:jwuille.42.fr,DNS:jwuille.42.fr,IP:127.0.0.1"

RUN rm -rf /var/log/nginx/*.log \
	&& ln -s /dev/stdout /var/log/nginx/access.log \
	&& ln -s /dev/stderr /var/log/nginx/error.log \
	&& touch /var/log/nginx/access.log /var/log/nginx/error.log

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx"]
