#!/usr/bin/env bash

build_docker_image() {
  local image_name="$1"
  local docker_file="$2"

  print_info "Building Docker image \"${image_name}\" with \"${docker_file}\""

  local current_dir=$(pwd)
  pushd "$(dirname "${docker_file}")"

  if [ -z "$3" ]; then
    docker build -t="${image_name}" -f "${docker_file}" .
  else
    local build_args="${@:3}"
    docker build --build-arg "${build_args}" -t="${image_name}" -f "${docker_file}" .
  fi

  local exit_code=$?
  popd
  if [[ ${exit_code} -ne 0 ]]; then
    assert_error "docker build failed (exit code: ${exit_code})"
  fi
}

tag_docker_image() {
  assert_not_empty_string "$1" "no image name provided"
  assert_not_empty_string "$2" "no tag provided"

  print_info "tagging docker image\n \"$1\" with tag \"$2\""
  docker rmi -f "$2" &> /dev/null
  docker tag "$1" "$2"
  assert_exit_code "docker tag failed"
}

pull_docker_image() {
  assert_not_empty_string "$1" "no image name provided"

  print_info "pulling image $1"
  docker pull "$1"
  assert_exit_code "docker pull failed"
}

push_docker_image() {
  assert_not_empty_string "$1" "no image name provided"

  print_info "Pushing the Docker image:$1"
  docker push "$1"
  assert_exit_code "docker push failed"
}

copy_docker_file() {
  assert_not_empty_string "$1" "no source path provided"
  assert_not_empty_string "$2" "no destination path provided"

  print_info "copying file from \"$1\" to \"$2\""
  docker cp "$1" "$2"
  assert_exit_code "docker copy failed"
}
