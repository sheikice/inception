FROM debian:12


RUN apt-get update && apt-get install -y --no-install-recommends vsftpd \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh
WORKDIR /var/www/html/wp-content/uploads

EXPOSE 21 30000 30001 30002 30003 30004 30005

ENTRYPOINT ["entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd.conf"]
