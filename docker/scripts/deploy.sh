#!/bin/bash

# usage: bash ./deploy.sh test-dockerize-store-api platform-api staging
endpoint=$1
app_name=$2
type=$3
image_namespace=$4

# if input is null, default is 'gomicorp'
if [ -z "$4" ]; then
    image_namespace=gomicorp
fi

ssh ${endpoint} "
    cd ~/${app_name}/${type};
    cat ~/.docker_password.txt | docker login --username lunacircle4 --password-stdin;
    docker pull ${image_namespace}/${app_name};
    docker-compose down;
    docker-compose up -d;
    docker system prune --volumes;
"
