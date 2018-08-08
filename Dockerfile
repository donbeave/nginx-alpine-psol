ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION}-alpine

ARG MOD_PAGESPEED_VERSION

RUN apk add --no-cache \
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
        zlib-dev

WORKDIR /usr/src

RUN git clone -b v${MOD_PAGESPEED_VERSION} \
              --recurse-submodules \
              --depth=1 \
              -c advice.detachedHead=false \
              -j`nproc` \
              https://github.com/apache/incubator-pagespeed-mod.git \
              modpagespeed

WORKDIR /usr/src/modpagespeed

COPY patches/modpagespeed/*.patch ./

RUN for i in *.patch; do printf "\r\nApplying patch ${i%%.*}\r\n"; patch -p1 < $i || exit 1; done

WORKDIR /usr/src/modpagespeed/tools/gyp
RUN ./setup.py install

WORKDIR /usr/src/modpagespeed

RUN build/gyp_chromium --depth=. \
                       -D use_system_libs=1 \
    && \
    cd /usr/src/modpagespeed/pagespeed/automatic && \
    make psol BUILDTYPE=Release \
              CFLAGS+="-I/usr/include/apr-1" \
              CXXFLAGS+="-I/usr/include/apr-1 -DUCHAR_TYPE=uint16_t" \
              -j`nproc`

RUN mkdir -p /psol/lib/Release/linux/x64; \
    mkdir -p /psol/include/out/Release; \
    \
    cp -R out/Release/obj /psol/include/out/Release/; \
    cp -R pagespeed/automatic/pagespeed_automatic.a /psol/lib/Release/linux/x64/; \
    cp -R net \
          pagespeed \
          testing \
          third_party \
          url \
          /psol/include/;

WORKDIR /usr/src/modpagespeed

RUN apk add --no-cache \
    		tar \
    		gzip

RUN tar -czvf psol.tar.gz /psol
