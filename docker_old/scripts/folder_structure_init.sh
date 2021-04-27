#!/bin/bash

# usage: bash ./folder_structure_init.sh store-api platform-api staging
endpoint=$1
app_name=$2
type=$3

ssh ${endpoint} "
  mkdir -p ~/${app_name}/${type}/log;
  touch ~/${app_name}/${type}/log/production.log;
  chmod o+w ~/${app_name}/${type}/log/production.log;
  sudo chown root:root  ~/${app_name}/${type}/log;
"
