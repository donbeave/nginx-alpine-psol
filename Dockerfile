ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION}-alpine

ARG MOD_PAGESPEED_VERSION

WORKDIR /usr/src

RUN set -ex \
	&& apk add --no-cache --virtual .build-deps \
               apache2-dev \
               apr-dev \
               apr-util-dev \
               build-base \
               curl \
               gettext-dev \
               git \
               gperf \
               icu-dev \
               libjpeg-turbo-dev \
               libpng-dev \
               libressl-dev \
               pcre-dev \
               py-setuptools \
               zlib-dev \
    && git clone -b v${MOD_PAGESPEED_VERSION} \
                 --recurse-submodules \
                 --depth=1 \
                 -c advice.detachedHead=false \
                 -j`nproc` \
                 https://github.com/apache/incubator-pagespeed-mod.git \
                 modpagespeed \
    && cd /usr/src/modpagespeed \
    && wget https://raw.githubusercontent.com/We-Amp/ngx-pagespeed-alpine/master/stable/3.8/nginx-stable/patches/modpagespeed/automatic_makefile.patch \
    && wget https://raw.githubusercontent.com/We-Amp/ngx-pagespeed-alpine/master/stable/3.8/nginx-stable/patches/modpagespeed/libpng16.patch \
    && wget https://raw.githubusercontent.com/We-Amp/ngx-pagespeed-alpine/master/stable/3.8/nginx-stable/patches/modpagespeed/pthread_nonrecursive_np.patch \
    && wget https://raw.githubusercontent.com/We-Amp/ngx-pagespeed-alpine/master/stable/3.8/nginx-stable/patches/modpagespeed/rename_c_symbols.patch \
    && wget https://raw.githubusercontent.com/We-Amp/ngx-pagespeed-alpine/master/stable/3.8/nginx-stable/patches/modpagespeed/stack_trace_posix.patch \
    && for i in *.patch; do printf "\r\nApplying patch ${i%%.*}\r\n"; patch -p1 < $i || exit 1; done \
    && cd /usr/src/modpagespeed/tools/gyp \
    && ./setup.py install \
    && cd /usr/src/modpagespeed \
    && build/gyp_chromium --depth=. \
                          -D use_system_libs=1 \
    && cd /usr/src/modpagespeed/pagespeed/automatic \
    && make psol BUILDTYPE=Release \
                 CFLAGS+="-I/usr/include/apr-1" \
                 CXXFLAGS+="-I/usr/include/apr-1 -DUCHAR_TYPE=uint16_t" \
                 -j`nproc` \
    && cd /usr/src/modpagespeed \
    && mkdir -p /psol/lib/Release/linux/x64 \
    && mkdir -p /psol/include/out/Release \
    && cp -R out/Release/obj /psol/include/out/Release/ \
    && cp -R pagespeed/automatic/pagespeed_automatic.a /psol/lib/Release/linux/x64/ \
    && cp -R net \
             pagespeed \
             testing \
             third_party \
             url \
             /psol/include/ \
    && apk add --no-cache \
               tar \
               gzip \
    && rm -rf /usr/src \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && tar -czvf /usr/src/psol.tar.gz /psol \
    && apk del .build-deps \
    && apk del tar \
               gzip \
    && rm -rf /psol

WORKDIR /usr/src
