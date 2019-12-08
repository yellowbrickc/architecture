#!/usr/bin/env bash

. ./_build/build-scripts/init-build-environment.sh

main() {
  local timer=$(timer)
  print_info "pipeline step 'build' started" true
  . ./_build/build-scripts/create-image.sh -d=Dockerfile
  print_info "pipeline step 'build' finished (duration: $(timer ${timer}))" true
}

main
