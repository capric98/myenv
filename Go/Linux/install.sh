#!/bin/bash
# Usage: curl -fsSL https://raw.githubusercontent.com/capric98/myenv/master/Go/Linux/install.sh | bash

VERSION=1.17.3
OS="linux"
ARCH="amd64"
if [[ $(uname --m) == "aarch64" ]]; then
    ARCH="arm64"
fi

curl -fsSL https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz -o go${VERSION}.${OS}-${ARCH}.tar.gz

if [[ -d /usr/local/go/ ]]; then
    # Update.
    echo "Golang exists:"
    echo `/usr/local/go/bin/go version`
    echo "Updating..."
else
    # First time.
    mkdir -p $HOME/.go
    echo "export GOPATH=\$HOME/.go" >> ~/.bashrc
    echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bashrc
fi

if [[ $EUID -ne 0 ]]; then
    sudo rm -rf /usr/local/go/
    sudo tar -C /usr/local -xzf go${VERSION}.${OS}-${ARCH}.tar.gz
else
    rm -rf /usr/local/go/
    tar -C /usr/local -xzf go${VERSION}.${OS}-${ARCH}.tar.gz
fi

echo "Golang installed:"
echo `/usr/local/go/bin/go version`

echo -e "\n======================================================================="
echo -e "If you are using Golang in Mainland China, you could enable goproxy by:"
echo -e "echo \"export GOPROXY=https://mirrors.aliyun.com/goproxy/\" >> ~/.bashrc"

rm -rf go${VERSION}.${OS}-${ARCH}.tar.gz
source ~/.bashrc
