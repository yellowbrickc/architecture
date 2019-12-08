#!/usr/bin/env bash

main() {
  export APPYARD_IMAGE=dockerregistry.sub.rocks/paas/appyard:b65db406ddc221b30928f29ac145005a2bbfd90d
  export CLUSTER_URL=http://devkub-node1.cgn.cleverbridge.com
  export IMAGE_NAME=dockerregistry.sub.rocks/aog/domain-events
  export LICENSE_WHITELIST_URL=https://git.sub.rocks/environment/license_whitelist/raw/master/whitelist.json
  export LOAD_BALANCING=default
  export METADATA_IMAGE_NAME=dockerregistry.sub.rocks/aog/domain-events_metadata
  export NAMESPACE=
  export PROJECT_NAME=domain-events
  export PROJECT_TYPE=npm
  export VALIDATION_IMAGE=dockerregistry.sub.rocks/paas/license-validation:latest
}

main
