# BaaS Infra

<!-- toc -->

- [Setup RKE2 Kubernetes HA Environment](#setup-rke2-kubernetes-ha-environment)
- [Setup Commands](#setup-commands)
  * [Install Traefik](#install-traefik)
  * [Local Development Certificate](#local-development-certificate)

<!-- tocstop -->

## Setup RKE2 Kubernetes HA Environment

1. Proxmox VE (1 Control Plane + 3 Worker Node)
2. Build NixOS System

## Setup Commands

### Install Traefik

```bash
# helm upgrade --install traefik traefik/traefik  -n traefik --create-namespace --values ./traefik/values.yml
just traefik
```

### Local Development Certificate

```bash
mkcert "*.baas.local" baas.local
# rename certs to .key/.crt
kubectl create secret -n traefik tls local-baas-tls --key local-baas.key --cert local-baas.crt
```
