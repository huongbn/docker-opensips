FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq && apt-get install -y --no-install-recommends git curl wget \
    ca-certificates gnupg2 dirmngr && rm -rf /var/lib/apt/lists

RUN apt-get update -qq && apt-get install -yqq python3-pip libpq-dev && rm -rf /var/lib/apt/lists

RUN pip3 install flask requests psycopg2 -U --force-reinstall

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 049AD65B
RUN echo "deb https://apt.opensips.org buster 2.4-releases" >/etc/apt/sources.list.d/opensips.list

RUN apt-get update -qq && apt-get install -yqq net-tools opensips opensips-json-module opensips-restclient-module \
    opensips-wss-module opensips-postgres-module opensips-console opensips-http-modules opensips-mysql-module\
    && rm -rf /var/lib/apt/lists/*

COPY opensips.cfg /etc/opensips/

EXPOSE 5060/udp
EXPOSE 8080/tcp

COPY mi_api.py /mi_api.py
COPY init.sh /init.sh
ENTRYPOINT ["/init.sh"]
