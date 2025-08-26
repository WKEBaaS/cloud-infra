<!-- markdownlint-disable MD004 MD013 -->

# Kubernetes Cloud Infra

<!-- toc -->

- [Setup RKE2 Kubernetes HA Environment](#setup-rke2-kubernetes-ha-environment)
- [Setup Kubernetes](#setup-kubernetes)
  * [Infra](#infra)
    + [Kyverno](#kyverno)
  * [Install Reflector to sync TLS secrets across namespaces](#install-reflector-to-sync-tls-secrets-across-namespaces)
    + [Syncing WKE/\*.BaaS TLS Secrets](#syncing-wkebaas-tls-secrets)
  * [Install Traefik (K8s ingress controller)](#install-traefik-k8s-ingress-controller)
  * [Install Longhorn (K8s Storage Provider)](#install-longhorn-k8s-storage-provider)
  * [Install CloudNativePG (Postgres Operator) via OLM](#install-cloudnativepg-postgres-operator-via-olm)
    + [Local Development Certificate](#local-development-certificate)

<!-- tocstop -->

## Setup RKE2 Kubernetes HA Environment

1. Proxmox VE (1 Control Plane + 3 Worker Node + 1 Load Balancer)
2. Build NixOS System

## Setup Kubernetes

### Infra

#### Kyverno

> The Kyverno project provides a comprehensive set of tools to manage the complete Policy-as-Code (PaC) lifecycle for Kubernetes and other cloud native environments

```bash
kubectl create -f https://github.com/kyverno/kyverno/releases/download/v1.15.1/install.yaml
```

### Install Reflector to sync TLS secrets across namespaces

> Custom Kubernetes controller that can be used to replicate secrets, configmaps and certificates.

```bash
#helm upgrade --install --namespace reflector --create-namespace reflector oci://ghcr.io/emberstack/helm-charts/reflector
just reflector-init
```

#### Syncing WKE/\*.BaaS TLS Secrets

1. Create WKE TLS Secret (make sure `Cert` is fullchain)
2. Add reflector annotations to the secret

```bash
just wke-tls-init
just baas-wildcard-tls-init
```

### Install Traefik (K8s ingress controller)

```bash
# helm upgrade --install traefik traefik/traefik  -n traefik-system --create-namespace --values ./traefik/values.yml
$ just traefik-init
```

### Install Longhorn (K8s Storage Provider)

[Ref: NixOS K3s Storage Example](https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/examples/STORAGE.md)

```bash
just longhorn-init
```

### Install CloudNativePG (Postgres Operator) via OLM

> CloudNativePG is an open source operator designed to manage highly available PostgreSQL databases with a primary/standby architecture on any supported Kubernetes cluster.

```bash
$ kubectl create -f https://operatorhub.io/install/cloudnative-pg.yaml
# To check CloudNativePG is installed successfully
$ kubectl get csv -n operators
```

#### Local Development Certificate

```bash
$ mkcert "*.baas.local" baas.local
# rename certs to .key/.crt
$ kubectl create secret -n traefik-system tls local-baas-tls --key local-baas.key --cert local-baas.crt
```
