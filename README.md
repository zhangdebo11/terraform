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

https://github.com/retail-ai-inc/docker-mongos

cloud build trigger `manju-mongos-staging-standard`

# install prometheus

安装前先创建 gcp_service_account，并赋予 monitoring metric writer 角色

```shell
kubectl create ns monitoring
helm upgrade --install -n monitoring -f staging-values.yaml prometheus ./
```

# install metrics-sidecar webhookconfig

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

# modify ArgoCD

修改app的目标集群

# 其他手动优化项

- https://github.com/retail-ai-inc/devops/blob/master/docs/Common_setup.md
- https://github.com/retail-ai-inc/devops/blob/master/docs/How_to_install_bbr.md
