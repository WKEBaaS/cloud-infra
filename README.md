# BaaS Infra

<!-- toc -->

- [Setup RKE2 Kubernetes HA Environment](#setup-rke2-kubernetes-ha-environment)
- [Setup Kubernetes](#setup-kubernetes)
  * [Infra](#infra)
    + [Kyverno](#kyverno)
    + [Operator Lifecycle Manager (OLM)](#operator-lifecycle-manager-olm)
  * [Install Traefik (K8s ingress controller)](#install-traefik-k8s-ingress-controller)
  * [Local Development Certificate](#local-development-certificate)
  * [Install Longhorn (K8s Storage Provider)](#install-longhorn-k8s-storage-provider)
  * [Install CloudNativePG (Postgres Operator)](#install-cloudnativepg-postgres-operator)

<!-- tocstop -->

## Setup RKE2 Kubernetes HA Environment

1. Proxmox VE (1 Control Plane + 3 Worker Node + 1 Load Balancer)
2. Build NixOS System

## Setup Kubernetes

### Infra

#### Kyverno

> The Kyverno project provides a comprehensive set of tools to manage the complete Policy-as-Code (PaC) lifecycle for Kubernetes and other cloud native environments

```bash
kubectl create -f https://github.com/kyverno/kyverno/releases/download/v1.13.0/install.yaml
```

#### Operator Lifecycle Manager (OLM)

> A tool to help manage the Operators running on your cluster.

```bash
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.32.0/install.sh | bash -s v0.32.0
```

### Install Traefik (K8s ingress controller)

```bash
# helm upgrade --install traefik traefik/traefik  -n traefik-system --create-namespace --values ./traefik/values.yml
just traefik-init
```

### Local Development Certificate

```bash
mkcert "*.baas.local" baas.local
# rename certs to .key/.crt
kubectl create secret -n traefik-system tls local-baas-tls --key local-baas.key --cert local-baas.crt
```

### Install Longhorn (K8s Storage Provider)

[Ref: NixOS K3s Storage Example](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/examples/STORAGE.md)

```bash
just longhorn-init
```

### Install CloudNativePG (Postgres Operator)

> CloudNativePG is an open source operator designed to manage highly available PostgreSQL databases with a primary/standby architecture on any supported Kubernetes cluster.

```bash
kubectl create -f https://operatorhub.io/install/cloudnative-pg.yaml
# To check CloudNativePG is installed successfully
kubectl get csv -n operators
```
