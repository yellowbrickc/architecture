#!/usr/bin/env bash

. ./_build/build-scripts/init-build-environment.sh

main() {
  local timer=$(timer)
  print_info "pipeline step 'publish' started" true
  local home_dir=$(docker run "${IMAGE_NAME}:${GIT_HASH}" sh -c 'cd ~ && pwd')
  assert_exit_code "get home dir failed"
  local container_id=$(docker create -e VERSION=0.0.0-"${BUILD_TAG}" --entrypoint="${home_dir}/publish-npm-package.sh" "${IMAGE_NAME}:${GIT_HASH}")
  assert_exit_code "docker create failed"
  copy_docker_file _build/build-scripts/publish-npm-package.sh "${container_id}:${home_dir}"
  assert_exit_code "copy publish-npm-package.sh failed"
  # copy does not work with absolute paths under windows
  cp  ~/.npmrc "${BUILD_DIR}"
  copy_docker_file build/.npmrc "${container_id}:${home_dir}"
  assert_exit_code "copy .npmrc failed"
  docker start -i "${container_id}"
  assert_exit_code "publish npm failed"
  print_info "pipeline step 'publish' finished (duration: $(timer ${timer}))" true
}

main
