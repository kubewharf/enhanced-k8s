#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

ROOT="$(dirname "${BASH_SOURCE}")/../.."

RELEASE="${RELEASE:-1.24}"

# The following can be overwritten for internal use
K8S_SRC_TGZ_URL="${K8S_SRC_TGZ_URL:-https://github.com/kubernetes/kubernetes/archive/refs/tags}"
KUBE_BASE_IMAGE_REGISTRY="${KUBE_BASE_IMAGE_REGISTRY:-k8s.gcr.io/build-image}"
KUBEADM_IMAGE_REGISTRY="${KUBEADM_IMAGE_REGISTRY:-k8s.gcr.io}"
KIND_PAUSE_IMAGE_TAG="${KIND_PAUSE_IMAGE_TAG:-}"

# Read K8S_VERSION, K8S_MD5, KUBEWHARF_VERSION, KUBEWHARF_COMMIT from release file
source "${ROOT}/releases/${RELEASE}/release"
KUBEWHARF_K8S_VERSION="${K8S_VERSION}-${KUBEWHARF_VERSION}"

SRC_DIR="${ROOT}/_source"
BUILD_DIR="${ROOT}/_output"
PATCH_DIR="${ROOT}/releases/${RELEASE}/patches"
