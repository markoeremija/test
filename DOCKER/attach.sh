#!/bin/bash

version=`docker version --format '{{.Client.Version}}'`

if [ "$version" == *"17"* ]; then
  docker container exec -it stretch-shib-idp-test01 /bin/bash
else
  # keep backward compatibility with older versions of Docker Engine
  docker exec -it stretch-shib-idp-test01 /bin/bash
