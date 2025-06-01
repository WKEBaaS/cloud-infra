# just is a command runner, Justfile is very similar to Makefile, but simpler.

source_dir := source_dir()
  
[group('helm')]
reflector-init:
  helm repo add emberstack https://emberstack.github.io/helm-charts
  helm repo update
  helm upgrade --install reflector emberstack/reflector --namespace reflector-system --create-namespace

wke-tls-init:
  kubectl create namespace wke
  kubectl create secret tls wke-tls --namespace wke \
    --cert={{source_dir}}/certs/wke.csie.ncnu.edu.tw_CER.cer \
    --key={{source_dir}}/certs/wke.csie.ncnu.edu.tw_KEY.key
  kubectl annotate secret --namespace wke wke-tls \
    'reflector.v1.k8s.emberstack.com/reflection-auto-enabled=true' \
    'reflector.v1.k8s.emberstack.com/reflection-allowed=true' \
    'reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces=traefik-system,keycloak,baas,baas-project'

baas-wildcard-tls-init:
  kubectl create namespace baas
  kubectl create namespace baas-project
  kubectl create secret tls baas-wildcard-tls --namespace baas \
    --cert={{source_dir}}/certs/_wildcard.baas.wke.csie.ncnu.edu.tw.crt \
    --key={{source_dir}}/certs/_wildcard.baas.wke.csie.ncnu.edu.tw-key.key
  kubectl annotate secret --namespace baas baas-wildcard-tls \
    'reflector.v1.k8s.emberstack.com/reflection-auto-enabled=true' \
    'reflector.v1.k8s.emberstack.com/reflection-allowed=true' \
    'reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces=baas-project,traefik-system'
  
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
  
[group('operator')]
keycloak-init:
  kubectl apply -f {{source_dir}}/keycloak/keycloak-operator.yml
  kubectl apply -f {{source_dir}}/keycloak/db.yml
  kubectl apply -f {{source_dir}}/keycloak/keycloak.yml

