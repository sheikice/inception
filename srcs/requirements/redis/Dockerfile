FROM debian:12

RUN set -eux &&  apt-get update && apt-get install -y \
	 redis-server

RUN mkdir /data && chown redis:redis /data
WORKDIR /data

COPY conf/redis.conf /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]
