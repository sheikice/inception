FROM debian:12

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld
    # && chown -R mysql:mysql /var/lib/mysql

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init_db.sh /usr/local/bin/init_db.sh

RUN chmod +x /usr/local/bin/init_db.sh

EXPOSE 3306

CMD ["init_db.sh"]
