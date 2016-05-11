#!/usr/bin/env bats

function setup() {
  ./scripts/install_ddf.sh -r
}

function teardown() {
  kill -9 $(pgrep java)
  rm -rf /opt/ddf
}

@test "it starts the container" {
  run pgrep -f ddf
  [ "$status" = 0 ]
}
