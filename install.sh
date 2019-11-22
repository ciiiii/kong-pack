#!/bin/bash

set -o errexit

OPENRESTY_VERSION=1.15.8.1
LUAROCKS_VERSION=3.1.3
OPENSSL_VERSION=1.1.1c

echo "*************************************************************************"
echo "Installing apt dependencies"
echo "*************************************************************************"

apt update -qq
apt install make gcc git libpcre3-dev libssl-dev perl build-essential curl zlib1g-dev unzip m4 libyaml-dev valgrind -y -qq

echo "*************************************************************************"
echo "Building openresty"
echo "*************************************************************************"

if [ -d "openresty-build-tools" ]; then
    echo "already clone"
    rm -rf openresty-build-tools/work rm -rf openresty-build-tools/buildroot
else
    git clone https://github.com/Kong/openresty-build-tools.git
fi
cd openresty-build-tools
./kong-ngx-build \
    -p buildroot \
    --openresty $OPENRESTY_VERSION \
    --openssl $OPENSSL_VERSION \
    --luarocks $LUAROCKS_VERSION \
    --force
cd ..
