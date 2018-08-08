#!/usr/bin/env bash

. ./env.sh;

echo "NGINX_VERSION=${NGINX_VERSION}"
echo "MOD_PAGESPEED_VERSION=${MOD_PAGESPEED_VERSION}"

docker build \
            -t donbeave/nginx-pagespeed-psol:${VERSION} \
            --build-arg NGINX_VERSION=${NGINX_VERSION} \
            --build-arg MOD_PAGESPEED_VERSION=${MOD_PAGESPEED_VERSION} \
            .
