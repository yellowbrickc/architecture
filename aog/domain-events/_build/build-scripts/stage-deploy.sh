#!/usr/bin/env bash

. ./_build/build-scripts/init-build-environment.sh

main() {
  local timer=$(timer)
  print_info "pipeline step 'deploy' started" true
  . ./_build/build-scripts/deploy.sh -e=dev
  print_info "pipeline step 'deploy' finished (duration: $(timer ${timer}))" true
}

main
