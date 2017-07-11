#!/bin/bash

# This command installs the newest Docker repository.
# It is the best practice to use this repository, instead of the
# one provided by a Linux distribution.
# Additionaly, the version used is v17.06, which has some changes
# in the way it's being run.
# More details: https://docs.docker.com/release-notes/docker-ce/

# Docker CE will not run on older Linux versions,
# or on versions that have kernel version < 3.10.
# This is also important for Docker Compose, because
# it won't run on Docker Engine versions lower than 1.10.
# Last version available on CentOS 6.x is 1.7.1.

centos_version=`cat /etc/centos-release | awk '{print $2}'`

if [[ "$centos_version" != *"7"*  ]]; then
  printf "You can use Docker on this version of OS, installing it from offical repository.\n"
  printf "In order to take full advantage of all new features, please upgrade to CentOS 7.\n"
else
  curl -sSL https://get.docker.com/ | sh
fi
