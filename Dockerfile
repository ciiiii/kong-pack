FROM ubuntu

WORKDIR /build
ADD . .
RUN bash install.sh
RUN tar -cvzf kong-dep-1.4.0.tgz openresty-build-tools
RUN ./upload kong-dep-1.4.0.tgz kong-dep-1.4.0.tgz