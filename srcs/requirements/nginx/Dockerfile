FROM debian:12

RUN apt-get update && apt-get install -y \
	nginx \
	openssl \
	procps \
	perl \
	&& rm -rf /var/lib/apt/lists/* \
	&& openssl genrsa -out /etc/ssl/private/mykey.pem 4096 \
	&& openssl req -new -x509 -key /etc/ssl/private/mykey.pem -out /etc/ssl/certs/ca.crt -days 1095 -subj "/CN=My-inception-CA" \
	&& openssl req -x509 -nodes -days 365 \
	-newkey rsa:4096 -keyout /etc/ssl/private/mykey.key -out /etc/ssl/certs/mycf.crt \
	-subj "/C=FR/ST=France/L=Paris/CN=jwuille.42.fr/emailAddress=bar@foo.fr" \
	-addext "subjectAltName=DNS:jwuille.42.fr,DNS:jwuille.42.fr,IP:127.0.0.1"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
