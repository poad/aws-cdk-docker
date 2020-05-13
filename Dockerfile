ARG JAVA_VERSION=11
ARG NODE_VERSION=14
ARG UBUNTU_VERSION=focal
ARG PYTHON_PIP_VERSION="20.1"
# https://github.com/docker-library/python/blob/master/3.8/buster/Dockerfile
ARG PIP_DOWNLOAD_HASH="1fe530e9e3d800be94e04f6428460fc4fb94f5a9"
ARG PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/${PIP_DOWNLOAD_HASH}/get-pip.py
ARG PYTHON_GET_PIP_SHA256="ce486cddac44e99496a702aa5c06c5028414ef48fdfd5242cd2fe559b13d4348"

FROM buildpack-deps:bionic-curl as downloader

ARG NODE_VERSION

ARG PYTHON_GET_PIP_URL
ARG PYTHON_GET_PIP_SHA256

WORKDIR /tmp

RUN apt-get update -qq \
 && apt-get install --no-install-recommends -qqy unzip \
 && curl -sLo setup_${NODE_VERSION}.x.sh https://deb.nodesource.com/setup_${NODE_VERSION}.x \
 && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && unzip awscliv2.zip \
 && wget -O get-pip.py "${PYTHON_GET_PIP_URL}" \
 && echo "${PYTHON_GET_PIP_SHA256} *get-pip.py" | sha256sum -c - \
 && curl -sLo yarnpkg.gpg.pub https://dl.yarnpkg.com/debian/pubkey.gpg


FROM ubuntu:${UBUNTU_VERSION}

ARG JAVA_VERSION
ARG NODE_VERSION

ENV DEBIAN_FRONTEND noninteractive

COPY --from=downloader /tmp/setup_${NODE_VERSION}.x.sh /tmp/setup_${NODE_VERSION}.x.sh
COPY --from=downloader /tmp/aws /tmp/aws
COPY --from=downloader /tmp/get-pip.py /tmp/get-pip.py
COPY --from=downloader /tmp/yarnpkg.gpg.pub /tmp/yarnpkg.gpg.pub

RUN mkdir -p /usr/share/man/man1 \
 && chmod +x /tmp/setup_${NODE_VERSION}.x.sh\
 && apt-get update -qq \
 && apt-get install --no-install-recommends -qqy \
    apt-transport-https \
    gnupg2 \
    dirmngr \
    gcc \
    g++ \
    make \
 && cat /tmp/yarnpkg.gpg.pub | apt-key add - \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
 && echo 'deb http://repos.azulsystems.com/debian stable main' > /etc/apt/sources.list.d/zulu.list \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
 && if [ "${UBUNTU_VERSION}" != "focal" ]; then \
      apt-get install --no-install-recommends -qqy ca-certificates lsb-release \
      && echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/python.list \
      && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xBA6932366A755776 \
      && apt-get update -qq \
      && apt-get install --no-install-recommends -qqy \
        python3.8 \
        python3.8-distutils \
        python3.8-lib2to3 \
      && rm -rf /usr/bin/python /usr/bin/python3 \
      && ln -s /usr/bin/python3.8 /usr/bin/python3 \
      && ln -s /usr/bin/python3 /usr/bin/python \
      ; \
    else \
      apt-get install --no-install-recommends -qqy \
        python3 \
        python3-distutils \
      && apt-get autoremove --purge -qqy *python2* \
      && apt-get install --no-install-recommends -qqy python-is-python3 \
      ; \
    fi \
 && python /tmp/get-pip.py \
 && /tmp/setup_${NODE_VERSION}.x.sh \
 && apt-get install --no-install-recommends -qqy zulu-${JAVA_VERSION} nodejs \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && ln -s /usr/bin/pip3 /usr/bin/pip \
 && /tmp/aws/install \
 && npm install -g aws-cdk typescript \
 && npm install -g yarn \
 && if [ "${UBUNTU_VERSION}" != "focal" ]; then \
      rm -rf /usr/bin/python /usr/bin/python3 \
    && ln -s /usr/bin/python3.8 /usr/bin/python3 \
    && ln -s /usr/bin/python3 /usr/bin/python \
    ; \
  fi \
 && rm -rf /tmp/*
