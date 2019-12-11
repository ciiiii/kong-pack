#!/bin/bash

set -o errexit

OPENRESTY_VERSION=1.15.8.1
LUAROCKS_VERSION=3.1.3
OPENSSL_VERSION=1.1.1c
KONG_VERSION=1.4.1

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
sudo ln -s "$(pwd)/buildroot/luarocks/bin/luarocks" /usr/bin/luarocks
luarocks --version
cd ..

echo "*************************************************************************"
echo "Installing kong"
echo "*************************************************************************"

wget -O kong.tgz "https://github.com/Kong/kong/archive/${KONG_VERSION}.tar.gz"
tar -xzvf kong.tgz
cd "kong-${KONG_VERSION}"
make install

cd ..
echo "*************************************************************************"
echo "Archive kong dependencies"
echo "*************************************************************************"
rm -rf openresty-build-tools/work
rm -rf openresty-build-tools/LICENSE
rm -rf openresty-build-tools/README.md
rm -rf openresty-build-tools/kong-ngx-build
rm -rf openresty-build-tools/t

tar -cvzf kong-dep-ubuntu18.04.tgz openresty-build-tools
