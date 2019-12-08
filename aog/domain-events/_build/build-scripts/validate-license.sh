#!/usr/bin/env bash

main() {
  print_info "locate source directory at docker image"
  temp_container_name="${PROJECT_NAME}-${BUILD_TAG}-${RANDOM}"
  package_path=$(docker run --name "${temp_container_name}" "${IMAGE_NAME}:${GIT_HASH}" \
    sh -c 'find $(pwd) -name package.json -type f -not -path */node_modules/* | tail -n1')
  assert_not_empty_string "${package_path}" "path of project package.json not found"
  src_dir=$(dirname "${package_path}")
  docker rm -f "${temp_container_name}"

  print_info "copy package.json files from directory tree '${src_dir}'"
  temp_container_name="${PROJECT_NAME}-${BUILD_TAG}-${RANDOM}"
  # the command must be split into two parts:
  # - one with variable expansion and
  # - one without variable expansion
  command_with_expansion="cd ${src_dir}"
  command_without_expansion='package_json_list=$(find . -name package.json) && for pakage_json in ${package_json_list}; do echo ${pakage_json}; package_json_dir=$(dirname ${pakage_json}); mkdir -p /tmp/license-validation/${package_json_dir}; cp ${pakage_json} /tmp/license-validation/${package_json_dir}; done'
  docker run --name "${temp_container_name}" "${IMAGE_NAME}:${GIT_HASH}" \
    "sh" "-c" "${command_with_expansion} && ${command_without_expansion}"
  assert_exit_code "could not copy package.json files inside container"
  license_validation_dir="${BUILD_DIR}/license-validation"
  mkdir -p "${license_validation_dir}"
  copy_docker_file "${temp_container_name}:/tmp/license-validation" "${BUILD_DIR}"
  docker rm -f "${temp_container_name}"

  print_info "start license validation "
  pull_docker_image "${VALIDATION_IMAGE}"
  docker run -e LICENSE_WHITELIST_URL -v "${license_validation_dir}:/src/validate-src" "${VALIDATION_IMAGE}" \
    "sh" "-c" "cd /src && grunt validateLicense"
  assert_exit_code "license validation failed"
}

main
