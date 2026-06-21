FROM debian:12


RUN apt-get update && apt-get install -y rsyslog netcat-openbsd \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/centralized
RUN sed -i 's/^module(load="imklog")/#module(load="imklog")/' /etc/rsyslog.conf


WORKDIR /var/log/centralized

COPY conf/syslog.conf /etc/rsyslog.d/syslog.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 514

CMD ["rsyslogd", "-n"]
