# create Cloud Storage bucket

用来保存terraform生成的状态文件，以及初始化脚本

```shell
gsutil mb gs://staging-standard-cluster
gsutil versioning set on gs://staging-standard-cluster
```

然后上传shell脚本 `system-init-script.sh`

# deploy cluster using terraform

cloud build trigger `terraform-standardcluster`

# install proxysql

https://github.com/retail-ai-inc/proxysql-k8s

```shell
kubectl create ns proxysql
helm upgrade --install -n proxysql -f values.yaml proxysql ./
```

# install mongos

```shell
kubectl create ns mongos
```

cloud build trigger `manju-mongos-staging-standard`

# install prometheus

安装前先创建 gcp_service_account ，并赋予 monitoring metric writer 角色

```shell
kubectl create ns monitoring
helm upgrade --install -n monitoring -f staging-manju-melonpan-cluster.values.yaml prometheus ./
```

# metrics-sidecar 迁移

首先删除所有集群的 mutatingwebhookconfiguration `metrics-sidecar-webhook-config`。

然后删除旧集群中的webhookserver服务。

```shell
helm -n metrics-sidecar-injector uninstall metrics-sidecar-injector
```

在新集群中创建 namespace `metrics-sidecar-injector`。

修改 trigger `metrics-sidecar-injector-staging-deploy` 中的变量 `_CLUSTER_` 值。执行trigger。

在所有集群中创建 mutatingwebhookconfiguration `metrics-sidecar-webhook-config`。

# migrate applications

## delete manju ingress in old cluster

```shell
kubectl delete ing manju

kubectl scale deploy manju --replicas=0

# kubectl delete managedcertificate sandbox-raicart-io-cert
```

## install manju in new cluster

```shell
kubectl create ns manju
helm upgrade --install -n manju -f staging-values.yaml manju ./

kubectl create ns gulab
helm upgrade --install -n gulab -f staging-values.yaml gulab ./

kubectl create ns macaron
helm upgrade --install -n macaron -f staging-values.yaml macaron ./

kubectl create ns monaka
helm upgrade --install -n monaka -f staging-values.yaml monaka ./

kubectl create ns melonpan
helm upgrade --install -n melonpan -f staging-values.yaml melonpan ./
```

会生成新的证书吗？

# modify cloudbuild

# modify ArgoCD

修改app的目标集群

# install toxiproxy