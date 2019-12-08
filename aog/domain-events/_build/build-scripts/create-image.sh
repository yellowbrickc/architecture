#!/usr/bin/env bash

main() {
  for i in "$@"; do
    case ${i} in
      -d=*|--dockerfile=*)
        local DOCKERFILE="${i#*=}"
        shift
      ;;
      *)
        print_warn "unknown parameter: \"${i}\" (will be ignored)"
      ;;
    esac
  done

  assert_file_exists ${DOCKERFILE}
  build_docker_image "${IMAGE_NAME}:${BUILD_TAG}" "${DOCKERFILE}"
  tag_docker_image "${IMAGE_NAME}:${BUILD_TAG}" "${IMAGE_NAME}:${GIT_HASH}"
  tag_docker_image "${IMAGE_NAME}:${BUILD_TAG}" "${IMAGE_NAME}:latestbuild"

  print_info "create metadata docker image"
  local metadata_dir="${BUILD_DIR}/metadata"
  mkdir -p ${metadata_dir}
  if [[ "${PROJECT_TYPE}" == "nodejs" ]] || [[ "${PROJECT_TYPE}" == "docker" ]]; then
    cp _build/contract.yaml ${metadata_dir}
    assert_exit_code "could not copy contract.yaml"
  fi
  pushd ${metadata_dir}
  local build_env_filename="build.env"
  env > ${build_env_filename}
  local metadata_dockerfile_name="Dockerfile.metadata"
  local git_remote=$(git ls-remote --get-url)
  if [[ "${PROJECT_TYPE}" == "nodejs" ]] || [[ "${PROJECT_TYPE}" == "docker" ]]; then
    cat > ${metadata_dockerfile_name} << EOF
FROM scratch

ADD contract.yaml /
ADD ${build_env_filename} /

LABEL GIT_REMOTE_URL=${git_remote}
LABEL GIT_COMMIT_HASH=${GIT_HASH}
LABEL VERSION_TAG=${BUILD_TAG}
LABEL PROJECT_TYPE=${PROJECT_TYPE}

# a dummy command for the entrypoint is required, otherwise a container cannot be created
ENTRYPOINT [\"tail\", \"-f\", \"/dev/null\"]
EOF
  elif [[ ${PROJECT_TYPE} == "npm" ]]; then
    // appyard setup does not create a contract.yaml for projects of type npm
    cat > ${metadata_dockerfile_name} << EOF
FROM scratch

ADD ${build_env_filename} /

LABEL GIT_REMOTE_URL=${git_remote}
LABEL GIT_COMMIT_HASH=${GIT_HASH}
LABEL VERSION_TAG=${BUILD_TAG}
LABEL PROJECT_TYPE=${PROJECT_TYPE}

# a dummy command for the entrypoint is required, otherwise a container cannot be created
ENTRYPOINT [\"tail\", \"-f\", \"/dev/null\"]
EOF
  else
    assert_error "Unknown project type ('${PROJECT_TYPE}')"
  fi

  build_docker_image "${METADATA_IMAGE_NAME}:${BUILD_TAG}" "${metadata_dockerfile_name}"
  tag_docker_image "${METADATA_IMAGE_NAME}:${BUILD_TAG}" "${METADATA_IMAGE_NAME}:${GIT_HASH}"
  tag_docker_image "${METADATA_IMAGE_NAME}:${BUILD_TAG}" "${METADATA_IMAGE_NAME}:latestbuild"
  popd
}

main "$@"
