#!/usr/bin/env bash

NGINX_VERSION="1.15.2"

# https://github.com/apache/incubator-pagespeed-mod/releases
MOD_PAGESPEED_VERSION="1.13.35.2"

VERSION="${MOD_PAGESPEED_VERSION}"

echo "NGINX_VERSION=${NGINX_VERSION}"
echo "MOD_PAGESPEED_VERSION=${MOD_PAGESPEED_VERSION}"

docker build \
            -t donbeave/nginx-pagespeed-psol:${VERSION} \
            --build-arg NGINX_VERSION=${NGINX_VERSION} \
            --build-arg MOD_PAGESPEED_VERSION=${MOD_PAGESPEED_VERSION} \
            .
