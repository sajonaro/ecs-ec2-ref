#!/usr/bin/env bash

# awscli needs to installed and configured, see https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 628654266155.dkr.ecr.us-east-1.amazonaws.com


HASH=$(openssl rand -hex 12)

docker build -t hello-world-app:${HASH}  ./app  --platform=linux/amd64

docker tag hello-world-app:${HASH} 628654266155.dkr.ecr.us-east-1.amazonaws.com/hello-world-app:${HASH}

docker push 628654266155.dkr.ecr.us-east-1.amazonaws.com/hello-world-app:${HASH}