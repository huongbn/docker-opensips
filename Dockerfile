FROM debian:buster

ENV DEBIAN_FRONTEND noninteractive
ENV OPENSIPS_CFG /etc/opensips/opensips.cfg

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    ca-certificates \
    gnupg2 \
    dirmngr \
    python3-pip \
    libpq-dev \
    runit   \
    procps  \
    parallel && \
    rm -rf /var/lib/apt/lists

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 049AD65B
RUN echo "deb https://apt.opensips.org buster 2.4-releases" >/etc/apt/sources.list.d/opensips.list

RUN apt-get update -qq && \
    apt-get install -yqq \
    net-tools \
    opensips \
    opensips-json-module \
    opensips-restclient-module \
    opensips-wss-module \
    opensips-postgres-module \
    opensips-console \
    opensips-http-modules \
    opensips-mysql-module \
    && rm -rf /var/lib/apt/lists/*

COPY opensips.cfg /etc/opensips/

ADD units /
RUN ln -s /etc/sv/* /etc/service

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 8888
EXPOSE 5060/udp

ENTRYPOINT ["/entrypoint.sh"]