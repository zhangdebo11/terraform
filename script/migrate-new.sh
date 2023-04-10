#!/usr/bin/bash

kubectl create ns macaron
kubectl create ns monaka
kubectl create ns gulab

########################################## ManagedCertificate ##########################################

cd /home/zhang_debo

cat >tmp_ManagedCertificate.yaml<<EOF
---
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: sandbox-gulab-raicart-io-cert
  namespace: gulab
spec:
  domains:
  - sandbox-gulab.raicart.io

---
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: sandbox-monaka-raicart-io-cert
  namespace: monaka
spec:
  domains:
  - sandbox-monaka.raicart.io
EOF

kubectl apply -f tmp_ManagedCertificate.yaml
rm -f tmp_ManagedCertificate.yaml

########################################## helm ##########################################

cd /home/zhang_debo/github/retail-ai-inc/manju-helm/manju
helm upgrade --install manju -f staging-values.yaml ./

cd /home/zhang_debo/github/retail-ai-inc/manju-helm/gulab
helm upgrade --install gulab -n gulab -f staging-values.yaml ./

cd /home/zhang_debo/github/retail-ai-inc/manju-helm/staging/macaron
helm upgrade --install macaron -n macaron -f values.yaml ./

cd /home/zhang_debo/github/retail-ai-inc/manju-helm/staging/monaka
helm upgrade --install monaka -n monaka -f values.yaml ./
