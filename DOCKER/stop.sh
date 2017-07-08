#!/bin/bash

# Get container name
container_name=`docker container ls | grep NAMES`

docker container stop $container_name && docker container rm $container_name
