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

```shell
kubectl create ns metrics-sidecar-injector
```

修改 trigger `metrics-sidecar-injector-staging-deploy` 中的变量 `_CLUSTER_` 值。执行trigger。

在所有集群中创建 mutatingwebhookconfiguration `metrics-sidecar-webhook-config`。

# migrate manju

删除旧集群中的manju服务

```sh
kubectl delete managedcertificate sandbox-raicart-io-cert
kubectl delete ing manju
```

在新集群中部署manju

```sh
helm upgrade --install manju  -f staging-values.yaml ./
```

修改armor规则对应的target

修改ArgoCD中manju配置

修改trigger `manju-develop-build` 中 `_CLUSTER` 的值



# migrate gulab

删除旧集群中的gulab服务

```sh
kubectl -n gulab delete managedcertificate sandbox-gulab-raicart-io-cert
kubectl -n gulab delete ing gulab
```

在新集群中创建证书

```yaml
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: sandbox-gulab-raicart-io-cert
  namespace: gulab
spec:
  domains:
  - sandbox-gulab.raicart.io
```

在新集群中部署gulab

```sh
kubectl create ns gulab
helm upgrade --install gulab -n gulab -f staging-values.yaml ./
```

修改armor规则对应的target

修改ArgoCD中gulab配置

修改trigger `gulab-develop-build` 中 `_CLUSTER` 的值



# migrate monaka

删除旧集群中的gulab服务

```sh
kubectl -n monaka delete managedcertificate sandbox-monaka-raicart-io-cert
kubectl -n monaka delete ing monaka
```

在新集群中创建证书

```yaml
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: sandbox-monaka-raicart-io-cert
  namespace: monaka
spec:
  domains:
  - sandbox-monaka.raicart.io
```

在新集群中部署 monaka

```sh
kubectl create ns monaka
helm upgrade --install monaka -n monaka -f values.yaml ./
```

修改armor规则对应的target

修改ArgoCD中 monaka 配置

修改trigger


# migrate macaron

删除旧集群中的 macaron 服务

```sh
kubectl -n macaron delete managedcertificate macaron-cert
kubectl -n macaron delete ing macaron
```


在新集群中部署 macaron

```sh
kubectl create ns macaron
helm upgrade --install macaron -n macaron -f values.yaml ./
```

修改armor规则对应的target

修改ArgoCD中 macaron 配置

修改trigger


# migrate toxiproxy

# migrate argocd
