# aws-cdk-docker

![Docker build and push](https://github.com/poad/aws-cdk-docker/workflows/Docker%20build%20and%20push/badge.svg)
[![GitHub issues](https://img.shields.io/github/issues/poad/aws-cdk-docker.svg "GitHub issues")](https://github.com/poad/aws-cdk-docker)
[![GitHub stars](https://img.shields.io/github/stars/poad/aws-cdk-docker.svg "GitHub stars")](https://github.com/poad/aws-cdk-docker)

Docker image for AWS CDK.

## Tags

| Tag | Node.js | OpenJDK | Linux Distribution |
|:---:|:---:|:---:|:---:|
| node-10-jdk8 | 10.x | Zulu Community 8 | Ubuntu 20.04 (Focal) |
| node-12-jdk8 | 12.x | Zulu Community 8 | Ubuntu 20.04 (Focal) |
| node-14-jdk8 | 14.x | Zulu Community 8 | Ubuntu 20.04 (Focal) |
| node-10-jdk11 | 10.x | Zulu Community 11 | Ubuntu 20.04 (Focal) |
| node-12-jdk11 | 12.x | Zulu Community 11 | Ubuntu 20.04 (Focal) |
| node-14-jdk11 | 14.x | Zulu Community 11 | Ubuntu 20.04 (Focal) |

### Python

Python 3.8.x by apt package

## Useage

```$sh
docker run --name cdk -it -v $(pwd):/work -v ~/.aws:/root/.aws poad/aws-cdk-docker:node-14-jdk11 bash
cd /work
```
