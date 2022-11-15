#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE}")/helper/setup.sh"
source "$(dirname "${BASH_SOURCE}")/helper/helper.sh"

# Download source
echo "download v${K8S_VERSION} k8s source..."
OUTPUT_DIR="${SRC_DIR}/${RELEASE}"
ARCHIVE_DIR="${SRC_DIR}/archives"
mkdir -p ${ARCHIVE_DIR}
rm -rf "${OUTPUT_DIR}"
helper::download_k8s_src "${K8S_VERSION}" "${K8S_MD5}" "${ARCHIVE_DIR}" "${OUTPUT_DIR}"

REL_PATCH_DIR="$(realpath --relative-to="${OUTPUT_DIR}" "${PATCH_DIR}")"
cd $OUTPUT_DIR

# Apply patches
echo "apply ${RELEASE} patches to k8s source..."
helper::apply_patch "${REL_PATCH_DIR}"

# Update version information
echo "update version information to ${KUBEWHARF_K8S_VERSION}..."
helper::patch_k8s_version "${K8S_VERSION}" "${KUBEWHARF_K8S_VERSION}" "${KUBEWHARF_COMMIT}"

echo "${KUBEWHARF_K8S_VERSION} source prepared"
echo

