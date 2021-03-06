#!/bin/bash

set -o errexit

OPENRESTY_VERSION=1.15.8.2
LUAROCKS_VERSION=3.1.3
OPENSSL_VERSION=1.1.1c
KONG_VERSION=2.1.0

cd /
sudo mkdir /kong-build
cd /kong-build

echo "*************************************************************************"
echo "Building openresty"
echo "*************************************************************************"

sudo git clone https://github.com/Kong/openresty-build-tools.git
cd openresty-build-tools
sudo ./kong-ngx-build \
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

sudo git clone https://github.com/Kong/kong.git
cd kong
sudo git checkout $KONG_VERSION
sudo make install

cd ..
echo "*************************************************************************"
echo "Archive kong dependencies"
echo "*************************************************************************"
sudo rm -rf openresty-build-tools/work
sudo rm -rf openresty-build-tools/LICENSE
sudo rm -rf openresty-build-tools/README.md
sudo rm -rf openresty-build-tools/kong-ngx-build
sudo rm -rf openresty-build-tools/t

sudo tar -cvzf kong-dep-ubuntu18.04.tgz openresty-build-tools
cd /
sudo tar -cvzf kong-ubuntu18.04.tgz /kong-build
