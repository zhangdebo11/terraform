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

# migrate applications

进入目录 /home/zhang_debo/github/retail-ai-inc/manju-helm 执行 git pull 更新代码

在新集群中执行脚本 `migrate-new.sh`

在旧集群中执行脚本 `migrate-old.sh`


修改armor规则对应的target

修改ArgoCD中app配置

修改trigger 中 `_CLUSTER` 的值


# migrate toxiproxy

# migrate argocd
