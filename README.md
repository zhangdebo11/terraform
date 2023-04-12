# create Cloud Storage bucket

用来保存terraform生成的状态文件，以及初始化脚本

```shell
gsutil mb gs://staging-standard-cluster
gsutil versioning set on gs://staging-standard-cluster
```

然后上传shell脚本 `system-init-script.sh`

# deploy cluster using terraform

cloud build trigger `terraform-standardcluster`

# prepare prometheus

安装前先创建 gcp_service_account ，并赋予 monitoring metric writer 角色

# 关闭 metrics-sidecar-webhook

删除所有集群的 mutatingwebhookconfiguration `metrics-sidecar-webhook-config`。

```sh
kubectl delete mutatingwebhookconfiguration metrics-sidecar-webhook-config
```

# migrate applications

```sh
cd /home/zhang_debo/github/retail-ai-inc/manju-helm
git pull

cd /home/zhang_debo/github/retail-ai-inc/proxysql-k8s
git pull

cd /home/zhang_debo/github/zhangdebo11/terraform
git pull
```


在新集群中执行脚本 `migrate-new.sh`

在旧集群中执行脚本 `migrate-old.sh`


修改armor规则对应的target

修改ArgoCD中app配置

修改trigger 中 `_CLUSTER` 的值

# 安装新的metrics-sidecar

修改 trigger `metrics-sidecar-injector-staging-deploy` 中的变量 `_CLUSTER_` 值。执行trigger。

在所有集群中创建 mutatingwebhookconfiguration `metrics-sidecar-webhook-config`。


# migrate toxiproxy

# migrate argocd
