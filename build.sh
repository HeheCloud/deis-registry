#!/usr/bin/env bash

# fail on any command exiting non-zero
set -eo pipefail

if [[ -z $DOCKER_BUILD ]]; then
  echo
  echo "Note: this script is intended for use by the Dockerfile and not as a way to build the registry locally"
  echo
  exit 1
fi

# install required packages (copied from dotcloud/docker-registry Dockerfile)
apk add --update-cache \
  build-base \
  git \
  openssl-dev \
  python-dev \
  libffi-dev \
  swig \
  libevent-dev \
  xz-dev

# install pip
curl -sSL https://raw.githubusercontent.com/pypa/pip/7.0.3/contrib/get-pip.py | python -
pip install --upgrade pip

# workaround to python > 2.7.8 SSL issues
pip install --disable-pip-version-check --no-cache-dir pyopenssl ndg-httpsclient pyasn1

# add the docker registry source from github
wget -O - "https://github.com/docker/docker-registry/archive/0.9.1.tar.gz" | tar -xz && \
  mv docker-registry-0.9.1 /docker-registry

# Install core
pip install --disable-pip-version-check --no-cache-dir /docker-registry/depends/docker-registry-core

# Install registry
pip install --disable-pip-version-check --no-cache-dir "file:///docker-registry#egg=docker-registry[bugsnag,newrelic,cors]"

# cleanup. indicate that python is a required package.
apk del --purge \
  build-base \
  linux-headers \
  python-dev

rm -rf /var/cache/apk/*
