FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends git curl wget \
    ca-certificates gnupg2 dirmngr && rm -rf /var/lib/apt/lists

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 049AD65B
RUN echo "deb https://apt.opensips.org buster 2.4-releases" >/etc/apt/sources.list.d/opensips.list

RUN apt-get update -qq && apt-get install -yqq net-tools opensips opensips-json-module opensips-restclient-module \
    opensips-wss-module opensips-postgres-module opensips-console opensips-http-modules \
    && rm -rf /var/lib/apt/lists/*

COPY opensips.cfg /etc/opensips/
RUN touch /var/log/opensips.log
RUN echo "local0.*              -/var/log/opensips.log" >> /etc/rsyslog.conf

EXPOSE 5060/udp
EXPOSE 8080/tcp

COPY init.sh /init.sh
ENTRYPOINT ["/init.sh"]
