#!/usr/bin/env sh
set -o pipefail

root_dir=$(pwd)

if [ $# -ne 2 ]; then
	echo
	echo "usage: $0 jdk_version node_version"
	exit -1
fi

JAVA_VERSION=$1
NODE_VERSION=$2

IMAGE_NAME=${DOCKER_USERNAME}/aws-cdk-docker:node-${NODE_VERSION}-jdk${JAVA_VERSION}

echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin

docker push ${IMAGE_NAME}
