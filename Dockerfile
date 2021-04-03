ARG JAVA_VERSION=11
ARG NODE_VERSION=14
ARG UBUNTU_VERSION=focal
ARG PYTHON_PIP_VERSION="21.0.1"
# https://github.com/docker-library/python/blob/master/3.9/buster/Dockerfile
ARG PIP_DOWNLOAD_HASH="29f37dbe6b3842ccd52d61816a3044173962ebeb"
ARG PYTHON_GET_PIP_URL=https://github.com/pypa/get-pip/raw/${PIP_DOWNLOAD_HASH}/public/get-pip.py
ARG PYTHON_GET_PIP_SHA256="e03eb8a33d3b441ff484c56a436ff10680479d4bd14e59268e67977ed40904de"

ARG NODE_SETUP_SHELL_PATH="/tmp/setup_${NODE_VERSION}.x.sh"

FROM buildpack-deps:bionic-curl as downloader

ARG NODE_VERSION

ARG PYTHON_GET_PIP_URL
ARG PYTHON_GET_PIP_SHA256

ARG NODE_SETUP_SHELL_PATH

WORKDIR /tmp

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -qq \
 && apt-get install --no-install-recommends -qqy unzip \
 && curl -sLo "${NODE_SETUP_SHELL_PATH}" "https://deb.nodesource.com/setup_${NODE_VERSION}.x" \
 && ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -sLo "/tmp/awscliv2.zip"; \
         ;; \
       amd64|x86_64) \
         curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -sLo "/tmp/awscliv2.zip"; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac \
 && unzip /tmp/awscliv2.zip \
 && curl -sLo /tmp/get-pip.py "${PYTHON_GET_PIP_URL}" \
 && echo "${PYTHON_GET_PIP_SHA256} *get-pip.py" | sha256sum --check --strict -


FROM buildpack-deps:${UBUNTU_VERSION}-curl

ARG JAVA_VERSION

ARG NODE_SETUP_SHELL_PATH


ENV DEBIAN_FRONTEND noninteractive

COPY --from=downloader ${NODE_SETUP_SHELL_PATH} ${NODE_SETUP_SHELL_PATH}
COPY --from=downloader /tmp/aws /tmp/aws
COPY --from=downloader /tmp/get-pip.py /tmp/get-pip.py

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN mkdir -p /usr/share/man/man1

RUN chmod +x "${NODE_SETUP_SHELL_PATH}" \
 && apt-get update -qq \
 && apt-get install --no-install-recommends -qqy \
    apt-transport-https \
    gnupg2 \
    dirmngr \
    gcc \
    g++ \
    make \
    ca-certificates \
    lsb-release \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
 && echo "deb [ arch=$(dpkg --print-architecture) ] https://repos.azul.com/zulu/deb/ stable main" > /etc/apt/sources.list.d/zulu-openjdk.list \
 && echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/python.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xBA6932366A755776 \
 && "${NODE_SETUP_SHELL_PATH}" \
 && apt-get update -qq \
 && apt-get install --no-install-recommends -qqy \
   python3.9 \
   python3.9-distutils \
   python3.9-lib2to3 \
   "zulu${JAVA_VERSION}" \
   nodejs \
 && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 \
 && update-alternatives --install /usr/bin/python python /usr/bin/python3 1 \
 && python /tmp/get-pip.py \
 && pip install -U pipenv \
 && npm install -g yarn aws-cdk typescript \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && /tmp/aws/install \
 && rm -rf /tmp/*

RUN groupadd --gid 1000 cdk \
  && useradd --uid 1000 --gid cdk --shell /bin/bash --create-home cdk

USER cdk

WORKDIR /home/cdk

RUN pipenv install pip
