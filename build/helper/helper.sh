#!/usr/bin/env bash

function helper::download_k8s_src() {
  local K8S_VERSION=$1
  local MD5SUM=$2
  local ARCHIVE_DIR=$3
  local OUTPUT_DIR=$4

  local DEST_FILE="${ARCHIVE_DIR}/v${K8S_VERSION}.tar.gz"

  if [[ -f "${DEST_FILE}" && "${MD5SUM}" == $(md5sum "${DEST_FILE}" | tr -s " " | cut -d " "  -f 1) ]];then
    echo "skip download as ${DEST_FILE} already exists..."
  else
    rm -f ${DEST_FILE}
    echo
    wget "${K8S_SRC_TGZ_URL}/v${K8S_VERSION}.tar.gz" -O "${DEST_FILE}"
  fi

  if [[ ! "${MD5SUM}" == $(md5sum "${DEST_FILE}" | tr -s " " | cut -d " " -f 1) ]]; then
    echo "${DEST_FILE} has invalid md5sum"
    rm -f "${DEST_FILE}"
    exit 1
  fi

  mkdir -p "${OUTPUT_DIR}"
  echo "extracting ${DEST_FILE} to ${OUTPUT_DIR}..."
  tar -xf "${DEST_FILE}" --strip-components=1 -C "${OUTPUT_DIR}"
}

function helper::apply_patch() {
  local PATCH_DIR=$1
  local patches=($(ls "${PATCH_DIR}"))

  echo
  for p in "${patches[@]}"; do
    local patch_number=$(echo "${p}" | cut -d "-" -f 1)
    echo "applying patch ${p}..."
    patch -p1 < "${PATCH_DIR}/${p}"
  done
  echo
}

function helper::patch_k8s_version() {
  local SRC_VERSION=$1
  local TARGET_VERSION=$2
  local COMMIT=$3

  sed -i -e "s|'tag: v${SRC_VERSION}'|'tag: v${TARGET_VERSION}'|g" hack/lib/version.sh
  sed -i -e "s|KUBE_GIT_COMMIT='[0-9a-z]\+'|KUBE_GIT_COMMIT='${COMMIT}'|g" hack/lib/version.sh
  sed -i -e "s|KUBE_GIT_TREE_STATE=\"archive\"|KUBE_GIT_TREE_STATE=\"clean\"|g" hack/lib/version.sh
}
