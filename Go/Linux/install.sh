#!/bin/bash
# Usage: curl -fsSL https://raw.githubusercontent.com/capric98/myenv/master/Go/Linux/install.sh | bash

VERSION=1.14
OS="linux"
ARCH="amd64"
if [[ $(uname --m) == "aarch64" ]]; then
    ARCH="arm64"
fi

wget https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz

if [[ -d /usr/local/go/ ]]; then
    # Update.
    echo "Golang exists:"
    echo `/usr/local/go/bin/go version`
    echo "Updating..."
    rm -rf /usr/local/go/
else
    # First time.
    mkdir -p $HOME/.go
    echo "export GOPATH=$HOME/.go" >> ~/.profile
    echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
fi

tar -C /usr/local -xzf go${VERSION}.${OS}-${ARCH}.tar.gz
echo "Golang installed:"
echo `/usr/local/go/bin/go version`

echo -e "\n======================================================================="
echo -e "If you are using Golang in Mainland China, you could enable goproxy by:"
echo -e "echo \"export GOPROXY=https://mirrors.aliyun.com/goproxy/\" >> ~/.profile"

rm -rf go${VERSION}.${OS}-${ARCH}.tar.gz
source ~/.profile
