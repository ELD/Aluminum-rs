#!/usr/bin/env bash

if [[ $TRAVIS_RUST_VERSION = 'stable' ]]; then
    wget https://github.com/SimonKagstrom/kcov/archive/master.zip
    unzip master.zip
    cd kcov-master
    mkdir build
    cd build
    cmake ..
    make
    make install DESTDIR=../../tmp
    cd ../..
    rm -rf kcov-master

    mkdir -p target/cov/aluminum
    mkdir -p target/cov/lib
    mkdir -p target/cov/merged
    tmp/usr/local/bin/kcov --exclude-pattern=/.cargo,/usr/lib,tests/ --verify target/cov target/debug/aluminum-*[^d]
    tmp/usr/local/bin/kcov --exclude-pattern=/.cargo,/usr/lib,tests/ --verify target/cov target/debug/lib-*[^d]

    bash <(curl -s https://codecov.io/bash) -s target/cov/merged
fi
