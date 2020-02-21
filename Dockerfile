FROM alpine:latest AS build_stage
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
RUN tar -xvzf suricata-*.tar.gz
RUN rm suricata-*.tar.gz
RUN cd suricata-* && ./configure --disable-gccmarch-native --enable-unittests --prefix=/usr --sysconfdir=/etc --localstatedir=/var && make -j${nproc} && make install DESTDIR=/suricata-docker && make install-conf DESTDIR=/suricata-docker


FROM alpine:latest
RUN apk add rsync libnet-dev nss-dev lz4-dev pcre-dev file-dev libcap-ng-dev jansson-dev libpcap-dev yaml-dev
WORKDIR /
COPY --from=build_stage suricata-docker/ /suricata-docker/
RUN rsync -rv --copy-links suricata-docker/* /
RUN usr/bin/suricata
