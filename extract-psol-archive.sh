#!/usr/bin/env bash

. ./env.sh;

docker run --rm -v $PWD:/tmp donbeave/nginx-pagespeed-psol:${VERSION} sh -c "cp /usr/src/psol.tar.gz /tmp/"
