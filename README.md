# KubeWharf Enhanced Kubernetes Distro

KubeWharf's enhanced Kubernetes distribution adds new features focused on large-scale cluster optimization, hybrid deployment of online and offline workloads, AI and Big Data on K8s, etc.

## Quickstart

For testing purposes, you can start a kind cluster with our Kubernetes distro by running `make kind`. This will create a kind cluster for release `1.24` by default. Note: this requires [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) to be installed.

To build the Kubernetes binaries, simply run `make`, which will build the binaries for release `1.24` by default. The binaries will be placed in the `_output/1.24` directory.

## Releases

Each release is based on a native Kubernetes version and ensures compatibility with the native API and features of its original version.

| Release | KubeWharf Version | Kubernetes Version | Go version |
| --- | --- | --- | --- |
| 1.24 | v1.24.6-kubewharf.0.1 | v1.24.6 | go1.18.6+ |

## How to build

### Source code

`RELEASE=1.24 make source` or `make source` which will build the source code for release `1.24` by default. The source code will be placed in the `_source/<RELEASE>/` directory.

### Binaries

`RELEASE=1.24 make` or `make` which will build the binaries for release `1.24` by default. The binaries will be placed in the `_output/<RELEASE>/` directory.

### Kind cluster

`RELEASE=1.24 make kind` or `make kind`, which will start a kind cluster for release `1.24` by default. Note: this requires [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) to be installed.
