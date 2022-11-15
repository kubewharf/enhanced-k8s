#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE}")/helper/setup.sh"
source "$(dirname "${BASH_SOURCE}")/helper/helper.sh"

# Prepare output directory
OUTPUT_DIR="${BUILD_DIR}/${RELEASE}"
mkdir -p "${OUTPUT_DIR}"

RELEASE_DIR="${SRC_DIR}/${RELEASE}"
REL_OUTPUT_DIR="$(realpath --relative-to="${RELEASE_DIR}" "${OUTPUT_DIR}")"

# Build binaries
echo "build binaries for ${RELEASE}..."

BINS=("kube-apiserver" "kube-controller-manager" "kube-scheduler"  "kube-proxy" "kubelet" "kubectl" "kubeadm")
TARGETS=""
for bin in ${BINS[@]}; do
  if [[ ! -f "${OUTPUT_DIR}/${bin}" ]]; then
    TARGETS+="${bin} "
  else
    echo "skipping ${bin} as it already exists..."
  fi
done

cd "${RELEASE_DIR}"
echo

if [[ ! -z "${TARGETS}" ]]; then
KUBE_BUILD_PLATFORMS=linux/amd64 make ${TARGETS}
echo
fi

# TODO: validate binary md5sum

cp _output/bin/kube* "${REL_OUTPUT_DIR}"
echo "${KUBEWHARF_K8S_VERSION} binaries built"

