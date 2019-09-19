#!/bin/bash
VERSION="1.13"
OS="linux"
ARCH="amd64"

wget https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz
tar -C /usr/local -xzf go${VERSION}.${OS}-${ARCH}.tar.gz

mkdir $HOME/.go
echo "export GOPROXY=https://mirrors.aliyun.com/goproxy/" >> ~/.profile
echo "export GOPATH=$HOME/.go" >> ~/.profile
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile

echo "Install some utils..."
apt-get update 1>/dev/null 2>&1
apt-get install build-essential autoconf automake pkg-config
