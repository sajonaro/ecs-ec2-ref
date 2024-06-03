#!/usr/bin/env bash

# awscli needs to installed and configured, see https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 730335574019.dkr.ecr.eu-central-1.amazonaws.com


HASH=$(openssl rand -hex 12)

docker build -t hello-world-app:${HASH}  ./app  --platform=linux/amd64

docker tag hello-world-app:${HASH} 730335574019.dkr.ecr.eu-central-1.amazonaws.com/hello-world-app:${HASH}

docker push 730335574019.dkr.ecr.eu-central-1.amazonaws.com/hello-world-app:${HASH}