#!/usr/bin/env bash

export NGINX_VERSION="1.15.2"

# https://github.com/apache/incubator-pagespeed-mod/releases
export MOD_PAGESPEED_VERSION="1.13.35.2"

export VERSION="${NGINX_VERSION}-${MOD_PAGESPEED_VERSION}-alpine"

export DOCKER_REPOSITORY="donbeave/nginx-pagespeed-psol"
