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

删除旧集群中的manju

```shell
helm uninstall manju
```

修改trigger `manju-develop-build` 和 `manju-develop-deploy` 中 `_CLUSTER` 的值，然后执行 trigger `manju-develop-build`

修改ArgoCD中manju配置

会生成新的证书吗？

# migrate argocd


# migrate toxiproxy
