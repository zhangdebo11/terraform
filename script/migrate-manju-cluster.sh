#!/usr/bin/bash

set -e

mkdir -p /home/zhang_debo/cluster_migration/manju_cluster
cd /home/zhang_debo/cluster_migration/manju_cluster

cat >tmp_namespace.yaml<<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: mongos

---
apiVersion: v1
kind: Namespace
metadata:
  name: proxysql

---
apiVersion: v1
kind: Namespace
metadata:
  name: macaron

---
apiVersion: v1
kind: Namespace
metadata:
  name: monaka

---
apiVersion: v1
kind: Namespace
metadata:
  name: gulab

---
apiVersion: v1
kind: Namespace
metadata:
  name: melonpan

---
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring

---
apiVersion: v1
kind: Namespace
metadata:
  name: metrics-sidecar-injector
EOF

kubectl apply -f tmp_namespace.yaml


########################################## ManagedCertificate ##########################################

cd /home/zhang_debo/cluster_migration/manju_cluster

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

---
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: sandbox-console-raicart-io-cert
  namespace: melonpan
spec:
  domains:
  - sandbox-console.raicart.io
EOF

kubectl apply -f tmp_ManagedCertificate.yaml


########################################## helm ##########################################

cd /home/zhang_debo/github/retail-ai-inc/proxysql-k8s/proxysql-cluster
helm upgrade --install -n proxysql -f values.yaml proxysql ./

cd /home/zhang_debo/github/retail-ai-inc/manju-helm/mongos
helm upgrade --install -n mongos -f staging-values.yaml mongos ./

cd /home/zhang_debo/github/zhangdebo11/terraform/helm-charts/prometheus
helm upgrade --install -n monitoring -f staging-manju-melonpan-cluster.values.yaml prometheus ./

# sleep 10

# cd /home/zhang_debo/github/retail-ai-inc/manju-helm/manju
# helm upgrade --install manju -f staging-values.yaml ./

# cd /home/zhang_debo/github/retail-ai-inc/manju-helm/gulab
# helm upgrade --install gulab -n gulab -f staging-values.yaml ./

# cd /home/zhang_debo/github/retail-ai-inc/manju-helm/melonpan
# helm upgrade --install melonpan -n melonpan -f staging-values.yaml ./

# cd /home/zhang_debo/github/retail-ai-inc/manju-helm/staging/macaron
# helm upgrade --install macaron -n macaron -f values.yaml ./

# cd /home/zhang_debo/github/retail-ai-inc/manju-helm/staging/monaka
# helm upgrade --install monaka -n monaka -f values.yaml ./

echo "***************************************** All done *****************************************"
