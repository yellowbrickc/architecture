#!/usr/bin/env bash

main() {
  export BUILD_DIR=$(pwd)/build
  if [[ -d "${BUILD_DIR}" ]]; then
    rm -rf "${BUILD_DIR}"
  fi

  mkdir "${BUILD_DIR}"
  export GIT_HASH=$(git rev-parse HEAD)
  export BUILD_TAG="build.${BUILD_NUMBER}"
  . ./_build/build-scripts/export-application-variables.sh
  . ./_build/build-scripts/build-functions.sh
  . ./_build/build-scripts/docker-functions.sh
}

main
