#!/usr/bin/env bash

main() {
  for i in "$@"; do
    case "${i}" in
      -e=*|--environment=*)
        local ENVIRONMENT="${i#*=}"
        shift
      ;;
      *)
        print_warn "unknown parameter: \"${i}\" (will be ignored)"
      ;;
    esac
  done

  if [[ -z "${APPYARD_IMAGE}" ]]; then
    print_error "no appyard image name provided"
    exit 1
  fi

  print_info "extract contract.yaml"
  local_contract=${BUILD_DIR}/contract.yaml
  pull_docker_image "${METADATA_IMAGE_NAME}:${BUILD_TAG}"
  container_id=$(docker create "${METADATA_IMAGE_NAME}:${BUILD_TAG}" "tail -f /dev/null")
  copy_docker_file "${container_id}:/contract.yaml" "${local_contract}"

  local_appyard="${BUILD_DIR}/appyard"
  pull_docker_image "${APPYARD_IMAGE}"

  appyard_container_id=$(docker create "${APPYARD_IMAGE}")

  docker cp "${appyard_container_id}:artifacts/linux/appyard" "${local_appyard}"
  assert_exit_code "Could not extract appyard binary"

  chmod +x "${local_appyard}"
  "${local_appyard}" contract --contractFile "${local_contract}" --type kubernetes --dockerTag "${BUILD_TAG}" > "${BUILD_DIR}/deployment.yaml"
  assert_exit_code "appyard contract command failed \n$(cat ${local_contract})\n"

  "${local_appyard}" deploy --environment="${ENVIRONMENT}" --loadBalancing="${LOAD_BALANCING}" --namespace="${NAMESPACE}" --project="${PROJECT_NAME}" --projectType="${PROJECT_TYPE}" --resourceConfig="${BUILD_DIR}/deployment.yaml"
  assert_exit_code "appyard deploy command failed"

  if [[ "${PROJECT_TYPE}" != "docker" ]]; then
    nodePort=$("${local_appyard}" status --environment="${ENVIRONMENT}"  --namespace="${NAMESPACE}" --project="${PROJECT_NAME}" --nodeport)
    printf "${CLUSTER_URL}:${nodePort}\n" > K8S_SERVICE_ENDPOINT
    print_info "Kubernetes service endpoint URL: $(cat K8S_SERVICE_ENDPOINT)"
  fi
}

main "$@"
