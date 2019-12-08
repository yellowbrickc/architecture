#!/usr/bin/env bash

. ./_build/build-scripts/init-build-environment.sh

main() {
  timer=$(timer)
  print_info "pipeline step 'push' started" true

  push_docker_image "${METADATA_IMAGE_NAME}:${BUILD_TAG}"
  push_docker_image "${METADATA_IMAGE_NAME}:${GIT_HASH}"
  push_docker_image "${METADATA_IMAGE_NAME}:latestbuild"

  push_docker_image "${IMAGE_NAME}:$BUILD_TAG"
  push_docker_image "${IMAGE_NAME}:$GIT_HASH"
  push_docker_image "${IMAGE_NAME}:latestbuild"

  print_info "pipeline step 'push' finished (duration: $(timer ${timer}))" true
}

main
