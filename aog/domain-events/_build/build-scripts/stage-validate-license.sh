#!/usr/bin/env bash

. ./_build/build-scripts/init-build-environment.sh

main() {
  local timer=$(timer)
  print_info "pipeline step 'validate-license' started" true
  . ./_build/build-scripts/validate-license.sh
  print_info "pipeline step 'validate-license' finished (duration: $(timer ${timer}))" true
}

main
