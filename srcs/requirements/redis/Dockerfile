FROM debian:12

RUN set -e &&  apt-get update && apt-get install -y --no-install-recommends \
	redis-server \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir /data && chown redis:redis /data
WORKDIR /data

COPY conf/redis.conf /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]
