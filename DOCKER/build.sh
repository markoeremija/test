#!/bin/bash

if [[ $1 == "tag" ]]; then
    TAG=`date +:%Y%m%d-%H%M%S`
elif [[ -n $1 ]]; then
    TAG=":$1"
else
    TAG=":latest"
fi

version=`docker version --format '{{.Client.Version}}'`

if [ "$version" == *"17"* ]; then
  docker image build -t stretch-shib-idp-test01$TAG .
else
  # keep backward compatibility with older versions of Docker Engine
  docker build -t stretch-shib-idp-test01$TAG .
