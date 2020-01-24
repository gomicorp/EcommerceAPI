#!/bin/bash

# usage: bash ./docker_env.sh test-dockerize-store-api

usage() {
  echo "Usage: $0 [your-ssh-entrypoint]" 1>&2;
  exit 1;
}

# Transform long options to short ones
for arg in "$@"; do
  shift
  case "$arg" in
    "--help") set -- "$@" "-h" ;;
    *)        set -- "$@" "$arg"
  esac
done

# if -h option; print usage
while getopts "h" option; do
    case "${option}" in
        h)
            usage
            ;;
        *)
            ;;
    esac
done

# if input is null; print usage
if [ -z "$1" ]; then
    usage
fi

#도커 패스워드 업데이트
rsync -avz ../.docker_password.txt ${1}:~/

ssh ${1} 'bash -s' < _docker_env.sh
