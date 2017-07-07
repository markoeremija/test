#!/bin/bash

# This command installs the newest Docker repository.
# It is the best practice to use this repository, instead of the
# one provided by a Linux distribution.
# Additionaly, the version used is v17.06, which has some changes
# in the way it's being run

curl -sSL https://get.docker.com/ | sh
