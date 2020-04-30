#!/usr/bin/env sh
set -o pipefail

root_dir=$(pwd)

if [ $# -ne 3 ]; then
	echo
	echo "usage: $0 version distribution linux_version"
	exit -1
fi

if [ $# -ne 2 ]; then
	echo
	echo "usage: $0 version distribution linux_version"
	exit -1
fi

JAVA_VERSION=$1
NODE_VERSION=$2

IMAGE_NAME=poad/aws-cdk-docker:node-${NODE_VERSION}-jdk${JAVA_VERSION}

echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin

docker push ${IMAGE_NAME}
