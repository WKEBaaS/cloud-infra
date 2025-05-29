# just is a command runner, Justfile is very similar to Makefile, but simpler.

source_dir := source_dir()
  
[group('helm')]
traefik-init:
  helm repo add traefik https://helm.traefik.io/traefik
  helm repo update
  helm upgrade --install traefik traefik/traefik --namespace traefik-system --create-namespace  \
    --values {{source_dir}}/traefik/values.yml
  
longhorn-init:
  helm repo add longhorn https://charts.longhorn.io
  helm repo update
  kubectl create namespace longhorn-system
  kubectl apply -f {{source_dir}}longhorn/nixos-path-cm.yml
  helm upgrade --install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.9.0 \
    --values {{source_dir}}/longhorn/values.yml
  
traefik:
  helm upgrade --install traefik traefik/traefik --namespace traefik-system --create-namespace  \
    --values {{source_dir}}/traefik/values.yml

longhorn:
  helm upgrade --install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.9.0 \
    --values {{source_dir}}/longhorn/values.yml
  
update-helm-repos:
  helm repo update
  
