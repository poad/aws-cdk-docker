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

IMAGE_NAME=poad/aws-cdk-docker:node-${NODE_VERSION}-jdk${JAVA_VERSION}

docker build --rm --build-arg JAVA_VERSION=${JAVA_VERSION} --build-arg NODE_VERSION=${NODE_VERSION} -t ${IMAGE_NAME} .
