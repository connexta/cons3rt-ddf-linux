#!/usr/bin/env bats
function setup() {
  ./scripts/install_ddf.sh -d /opt/foo
}

function teardown() {
  rm -rf /opt/foo
}

@test "it creates /opt/foo" {
  run stat /opt/foo
  [ "$status" = 0 ]
}
