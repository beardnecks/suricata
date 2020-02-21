FROM alpine AS build_stage
RUN apk update
RUN apk add ca-certificates
RUN apk add \
                autoconf \
                automake \
                cargo \
                diffutils \
                file-dev \
                gcc \
                g++ \
                git \
                jansson-dev \
                jq \
                lua-dev \
                libtool \
                yaml-dev \
                libnfnetlink-dev \
                libnetfilter_queue-dev \
                libnet-dev \
                libcap-ng-dev \
                libevent-dev \
                libmaxminddb-dev \
                libpcap-dev \
                libtool \
                lz4-dev \
                make \
                nss-dev \
                pcre-dev \
                pkgconfig \
                python3-dev \
		sphinx \
		py-yaml \
                rust \
                sudo \
                which \
                zlib-dev
RUN cargo install --force cbindgen
ENV PATH="/root/.cargo/bin:${PATH}"
COPY suricata-*.tar.gz ${PWD}
RUN tar -tf suricata-*.tar.gz
RUN tar -xvzf suricata-*.tar.gz
RUN rm suricata-*.tar.gz

FROM build_stage
RUN ls -la suricata-*
RUN cd suricata-* && ls -la && ./configure --disable-gccmarch-native --enable-unittests --prefix=/usr --sysconfdir=/etc --localstatedir=/var && make -j$(nproc) && make install-full
