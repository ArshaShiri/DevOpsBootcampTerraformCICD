#!/usr/bin/env bash

# Get the image name as a value that is passed to this script.
# Set it as an envirnoment variable on our server (EC2)
export IMAGE=$1
export DOCKER_USER=$2
export DOCKER_PWD=$3
echo $DOCKER_PWD | docker login -u $DOCKER_USER --password-stdin
docker-compose -f docker-compose.yaml up --detach
echo "success"

