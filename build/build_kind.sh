#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE}")/helper/setup.sh"
source "$(dirname "${BASH_SOURCE}")/helper/helper.sh"

RELEASE_DIR="${SRC_DIR}/${RELEASE}"

# Prepare fake gopath
FAKE_GOPATH=$(mktemp -d)
mkdir -p "${FAKE_GOPATH}/src/k8s.io"

# Copy source to fake gopath
cp -r "${RELEASE_DIR}" "${FAKE_GOPATH}/src/k8s.io/kubernetes"

# Prepare kind config
KIND_CONFIG=$(mktemp)
cat <<EOF > ${KIND_CONFIG}
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: ClusterConfiguration
    etcd:
      local:
        imageRepository: ${KUBEADM_IMAGE_REGISTRY}
    dns:
      imageRepository: ${KUBEADM_IMAGE_REGISTRY}
- role: worker
- role: worker
EOF

# Build custom node image
IMAGE="kindest/node:v${KUBEWHARF_K8S_VERSION}"
echo "build custom kind node image for v${KUBEWHARF_K8S_VERSION}..."
if [[ $(docker images -q ${IMAGE}) ]]; then
  echo "image ${IMAGE} already found, skipping..."
else
  echo
  GOPATH=$FAKE_GOPATH kind build node-image --image="${IMAGE}"
  if [[ ! -z ${KIND_PAUSE_IMAGE_TAG} ]]; then
    echo "overwriting pause image with ${KIND_PAUSE_IMAGE_TAG}..."
    DOCKERFILE=$(mktemp)
    cat <<EOF > ${DOCKERFILE}
FROM ${IMAGE}
RUN sed -i -e "s|registry.k8s.io/pause:3.7|${KIND_PAUSE_IMAGE_TAG}|g" /etc/containerd/config.toml
EOF
    docker build -f "${DOCKERFILE}" -t ${IMAGE} .
  fi
fi

# Start kind cluster
echo "starting cluster for ${KUBEWHARF_K8S_VERSION}..."
kind create cluster --image="${IMAGE}" --config="${KIND_CONFIG}" --name "${KUBEWHARF_K8S_VERSION}" --retain
echo

echo "kind cluster ${KUBEWHARF_K8S_VERSION} started"
echo
