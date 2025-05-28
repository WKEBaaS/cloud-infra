# just is a command runner, Justfile is very similar to Makefile, but simpler.
  
[group('helm')]
traefik:
  helm upgrade --install traefik traefik/traefik --namespace traefik --create-namespace  \
    --values {{source_dir()}}/traefik/values.yml \
