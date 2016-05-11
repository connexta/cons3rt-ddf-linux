#!/usr/bin/env bats

function setup() {
  ./scripts/install_ddf.sh
}

function teardown() {
	rm -rf /opt/ddf
}

@test "it creates /opt/ddf" {
  run stat /opt/ddf
  [ "$status" = 0 ]
}

@test "it should contain a ddf installation" {
  run stat /opt/ddf/ddf-$(cat ./scripts/DDF_VERSION)
  [ "$status" = 0 ]
}

@test "it should add DDF_HOME to the environment" {
  run grep -Fxq "export DDF_HOME=/opt/ddf/ddf-$(cat scripts/DDF_VERSION)" /etc/environment
  [ "$status" = 0 ]
}
