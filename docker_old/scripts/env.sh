#!/bin/bash

# usage: bash ./env.sh test-dockerize-store-api platform-api staging
endpoint=$1
app_name=$2
type=$3

#마스터키 업데이트
rsync -avz ../../config/master.key ${endpoint}:~/${app_name}/${type}/

#환경변수 업데이트
rsync -avz ../.envs/${type}/.env ${endpoint}:~/${app_name}/${type}/

#nginx config 업데이트
rsync -avz ../nginx/${type}/nginx.conf ${endpoint}:~/${app_name}/${type}

#docker_old-compose 업데이트
rsync -avz ../docker-compose/${type}/docker-compose.yml ${endpoint}:~/${app_name}/${type}

#entrypoint 업데이트
rsync -avz ../docker-compose/${type}/entrypoint.sh ${endpoint}:~/${app_name}/${type}
ssh ${endpoint} "chmod u+x ~/${app_name}/${type}/entrypoint.sh"
