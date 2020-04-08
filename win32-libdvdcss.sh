#!/bin/bash

if [ -z "$1" ]; then
        echo "Usage: $0 path-to-final.dll"
        exit 1
fi

fin = $(pwd)

if [ -z "$SKIP_DEPS" ]; then
        sudo apt update
        sudo apt install -y mingw-w64 git build-essential autoconf libtool
fi

cd $(mktemp -d -t ldc-XXXXXXX)

git clone https://code.videolan.org/videolan/libdvdcss.git .
git checkout $(git describe --tags `git rev-list --tags --max-count=1`) # check out latest tag

autoreconf -i

if [ -z "$IS_32" ]; then
        ./configure --host=x86_64-w64-mingw32
else
        ./configure --host=i686-w64-mingw32
fi

make

home=$(pwd)
cd $fin

mv $home/.libs/libdvdcss-2.dll $1

echo "Installed to $1"
rm -rf $home
