# aws-cdk-docker

![Docker build and push](https://github.com/poad/aws-cdk-docker/workflows/Docker%20build%20and%20push/badge.svg)
[![GitHub issues](https://img.shields.io/github/issues/poad/aws-cdk-docker.svg "GitHub issues")](https://github.com/poad/aws-cdk-docker)
[![GitHub stars](https://img.shields.io/github/stars/poad/aws-cdk-docker.svg "GitHub stars")](https://github.com/poad/aws-cdk-docker)

Docker image for AWS CDK.

## Tags

| Tag | Node.js | OpenJDK | Linux Distribution |
|:---:|:---:|:---:|:---:|
| node12-jdk8-xenial  | 12.x | Zulu Community 8  | Ubuntu 16.04 (Xenial) |
| node12-jdk8-bionic  | 12.x | Zulu Community 8  | Ubuntu 18.04 (Bionic) |
| node12-jdk8-focal   | 12.x | Zulu Community 8  | Ubuntu 20.04 (Focal)  |
| node12-jdk11-xenial | 12.x | Zulu Community 11 | Ubuntu 16.04 (Xenial) |
| node12-jdk11-bionic | 12.x | Zulu Community 11 | Ubuntu 18.04 (Bionic) |
| node12-jdk11-focal  | 12.x | Zulu Community 11 | Ubuntu 20.04 (Focal)  |
| node12-jdk14-xenial | 12.x | Zulu Community 16 | Ubuntu 16.04 (Xenial) |
| node12-jdk14-bionic | 12.x | Zulu Community 16 | Ubuntu 18.04 (Bionic) |
| node12-jdk14-focal  | 12.x | Zulu Community 16 | Ubuntu 20.04 (Focal)  |
| node14-jdk8-xenial  | 14.x | Zulu Community 8  | Ubuntu 16.04 (Xenial) |
| node14-jdk8-bionic  | 14.x | Zulu Community 8  | Ubuntu 18.04 (Bionic) |
| node14-jdk8-focal   | 14.x | Zulu Community 8  | Ubuntu 20.04 (Focal)  |
| node14-jdk11-xenial | 14.x | Zulu Community 11 | Ubuntu 16.04 (Xenial) |
| node14-jdk11-bionic | 14.x | Zulu Community 11 | Ubuntu 18.04 (Bionic) |
| node14-jdk11-focal  | 14.x | Zulu Community 11 | Ubuntu 20.04 (Focal)  |
| node14-jdk14-xenial | 14.x | Zulu Community 16 | Ubuntu 16.04 (Xenial) |
| node14-jdk14-bionic | 14.x | Zulu Community 16 | Ubuntu 18.04 (Bionic) |
| node14-jdk14-focal  | 14.x | Zulu Community 16 | Ubuntu 20.04 (Focal)  |

### Python

Installed Python 3.9.x with the apt package.

## Useage

```$sh
docker run --name cdk -it -v $(pwd):/work -v ~/.aws:/home/cdk/.aws poad/aws-cdk-docker:node-14-jdk11 bash
pipenv shell
cd /work
```
