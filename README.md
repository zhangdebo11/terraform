# create Cloud Storage bucket

```shell
gsutil mb gs://smartcart-stagingization-tfstate
gsutil versioning set on gs://smartcart-stagingization-tfstate
```

# deploy cluster using terraform

# install proxysql

https://github.com/retail-ai-inc/proxysql-k8s

```shell
kubectl create ns proxysql
helm upgrade --install -n proxysql -f values.yaml proxysql ./
```

# install prometheus
创建 gcp_service_account 赋予 monitoring metric writer 角色

```shell
kubectl create ns monitoring
helm upgrade --install -n monitoring -f staging-values.yaml prometheus ./
```

# migrate manju

## delete manju ingress in old cluster

```shell
kubectl delete ing manju
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

# modify ArgoCD

# 其他手动优化项

- https://github.com/retail-ai-inc/devops/blob/master/docs/Common_setup.md
- https://github.com/retail-ai-inc/devops/blob/master/docs/How_to_install_bbr.md
