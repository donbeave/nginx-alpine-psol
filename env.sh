#!/usr/bin/env bash

export NGINX_VERSION="1.15.2"

# https://github.com/apache/incubator-pagespeed-mod/releases
export MOD_PAGESPEED_VERSION="1.13.35.2"

export DOCKER_REPOSITORY="donbeave/nginx-pagespeed-psol"

export VERSION="${MOD_PAGESPEED_VERSION}_${NGINX_VERSION}-alpine"

echo "NGINX_VERSION         = ${NGINX_VERSION}"
echo "MOD_PAGESPEED_VERSION = ${MOD_PAGESPEED_VERSION}"
echo "DOCKER_REPOSITORY     = ${DOCKER_REPOSITORY}"
echo "VERSION               = ${VERSION}"
echo ""
