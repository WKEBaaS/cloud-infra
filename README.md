# BaaS Infra

<!-- toc -->

- [Setup RKE2 Kubernetes HA Environment](#setup-rke2-kubernetes-ha-environment)
- [Setup Commands](#setup-commands)
  * [Install Traefik](#install-traefik)
  * [Local Development Certificate](#local-development-certificate)
  * [Longhorn: Kubernetes Storage Provider](#longhorn-kubernetes-storage-provider)

<!-- tocstop -->

## Setup RKE2 Kubernetes HA Environment

1. Proxmox VE (1 Control Plane + 3 Worker Node + 1 Load Balancer)
2. Build NixOS System

## Setup Commands

### Install Traefik

```bash
# helm upgrade --install traefik traefik/traefik  -n traefik-system --create-namespace --values ./traefik/values.yml
just traefik
```

### Local Development Certificate

```bash
mkcert "*.baas.local" baas.local
# rename certs to .key/.crt
kubectl create secret -n traefik tls local-baas-tls --key local-baas.key --cert local-baas.crt
```

### Longhorn: Kubernetes Storage Provider

[NixOS K3s Storage Example](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/examples/STORAGE.md)

1. kyverno

```bash
kubectl create -f https://github.com/kyverno/kyverno/releases/download/v1.13.0/install.yaml
```

2. Longhorn

```bash
just longhorn
```
