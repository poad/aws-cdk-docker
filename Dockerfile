ARG JAVA_VERSION=11
ARG NODE_VERSION=14
ARG UBUNTU_VERSION=focal

FROM buildpack-deps:bionic-curl as downloader

ARG NODE_VERSION

WORKDIR /tmp

RUN apt-get update -qq \
 && apt-get install --no-install-recommends -qqy unzip \
 && curl -sLo setup_${NODE_VERSION}.x.sh https://deb.nodesource.com/setup_${NODE_VERSION}.x \
 && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && unzip awscliv2.zip


FROM ubuntu:${UBUNTU_VERSION}

ARG JAVA_VERSION
ARG NODE_VERSION

ENV DEBIAN_FRONTEND noninteractive

COPY --from=downloader /tmp/setup_${NODE_VERSION}.x.sh /tmp/setup_${NODE_VERSION}.x.sh
COPY --from=downloader /tmp/aws /tmp/aws

RUN mkdir -p /usr/share/man/man1 \
 && chmod +x /tmp/setup_${NODE_VERSION}.x.sh\
 && apt-get update -qq \
 && apt-get install --no-install-recommends -qqy gnupg2 dirmngr python3 python3-setuptools python3-pip python-is-python3 \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
 && echo 'deb http://repos.azulsystems.com/debian stable main' > /etc/apt/sources.list.d/zulu.list \
 && /tmp/setup_${NODE_VERSION}.x.sh \
 && apt-get install --no-install-recommends -qqy zulu-${JAVA_VERSION} nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s /usr/bin/pip3 /usr/bin/pip \
 && /tmp/aws/install \
 && npm install -g aws-cdk typescript \
 && npm install -g yarn \
 && rm -rf /tmp/*
