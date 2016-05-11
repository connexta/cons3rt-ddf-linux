#!/usr/bin/env bats

function setup() {
  ./scripts/install_ddf.sh -s
}

function teardown() {
  kill -9 $(pgrep ddf)
  rm -rf /opt/ddf
}
