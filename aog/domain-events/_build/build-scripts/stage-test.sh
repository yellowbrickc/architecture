#!/usr/bin/env bash

. ./_build/build-scripts/init-build-environment.sh

main() {
  local timer=$(timer)
  print_info "pipeline step 'test' started" true
  docker run "${IMAGE_NAME}:${BUILD_TAG}" /bin/sh -c 'eval $RUN_TESTS'
  assert_exit_code "Executing tests in a Docker image failed"
  print_info "pipeline step 'test' finished (duration: $(timer ${timer}))" true
}

main
