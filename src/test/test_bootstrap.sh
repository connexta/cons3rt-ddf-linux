#!/usr/bin/env bash

./bats/install.sh /usr/local

./defaults.bats
./run.bats
# ./service.bats
./altdir.bats
