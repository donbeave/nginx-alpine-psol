#!/usr/bin/env bash
export TERM="dumb"

printf "\n> \e[93m\033[1mBuild\e[0m\n\n"

set -e

ABSOLUTE_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
cd ${ABSOLUTE_PATH}

. ./env.sh;

echo "NGINX_VERSION=${NGINX_VERSION}"
echo "MOD_PAGESPEED_VERSION=${MOD_PAGESPEED_VERSION}"

docker build \
            -t ${DOCKER_REPOSITORY}:${VERSION} \
            --build-arg NGINX_VERSION=${NGINX_VERSION} \
            --build-arg MOD_PAGESPEED_VERSION=${MOD_PAGESPEED_VERSION} \
            .
