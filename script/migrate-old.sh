#!/usr/bin/bash

kubectl -n default delete ing manju
kubectl -n gulab delete ing gulab
kubectl -n monaka delete ing monaka
kubectl -n macaron delete ing macaron
kubectl -n melonpan delete ing melonpan-api-gce

kubectl -n default delete ManagedCertificate sandbox-raicart-io-cert
kubectl -n gulab delete ManagedCertificate sandbox-gulab-raicart-io-cert
kubectl -n monaka delete ManagedCertificate sandbox-monaka-raicart-io-cert
kubectl -n macaron delete ManagedCertificate macaron-cert
kubectl -n melonpan delete ManagedCertificate sandbox-console-raicart-io-cert

kubectl -n default scale deploy manju --replicas=0
kubectl -n gulab scale deploy gulab --replicas=0
kubectl -n monaka scale deploy monaka --replicas=0
kubectl -n macaron scale deploy macaron  --replicas=0
kubectl -n melonpan scale deploy melonpan-queue-box  --replicas=0
kubectl -n melonpan scale deploy melonpanbox  --replicas=0
kubectl -n melonpan scale deploy openresty  --replicas=0

helm -n metrics-sidecar-injector uninstall metrics-sidecar-injector

# helm -n default uninstall manju 
# helm -n gulab uninstall gulab 
# helm -n monaka uninstall monaka 
# helm -n macaron uninstall macaron
# helm -n melonpan uninstall melonpan
