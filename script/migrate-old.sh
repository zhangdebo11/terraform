#!/usr/bin/bash

kubectl -n default delete ing manju
kubectl -n gulab delete ing gulab
kubectl -n monaka delete ing monaka
kubectl -n macaron delete ing macaron

kubectl -n default delete ManagedCertificate sandbox-raicart-io-cert
kubectl -n gulab delete ManagedCertificate sandbox-gulab-raicart-io-cert
kubectl -n monaka delete ManagedCertificate sandbox-monaka-raicart-io-cert
kubectl -n macaron delete ManagedCertificate macaron-cert

kubectl -n default scale deploy manju --replicas=0
kubectl -n gulab scale deploy gulab --replicas=0
kubectl -n monaka scale deploy monaka --replicas=0
kubectl -n macaron scale deploy macaron  --replicas=0

# helm -n default uninstall manju 
# helm -n gulab uninstall gulab 
# helm -n monaka uninstall monaka 
# helm -n macaron uninstall macaron
