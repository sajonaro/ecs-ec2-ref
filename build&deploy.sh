#!/usr/env/bin bash

./build_push_to_ecr.sh
sudo docker compose run --rm tf apply -var-file .tfvars -auto-approve 