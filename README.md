# create Cloud Storage bucket

```shell
gsutil mb gs://smartcart-stagingization-tfstate
gsutil versioning set on gs://smartcart-stagingization-tfstate
```

# install proxysql

https://github.com/retail-ai-inc/proxysql-k8s
kubectl create ns proxysql
helm upgrade --install -n proxysql -f values.yaml proxysql ./

# install prometheus
创建 gcp_service_account 赋予 monitoring metric writer 角色

kubectl create ns monitoring
helm upgrade --install -n monitoring -f staging-values.yaml prometheus ./

# install manju
kubectl create ns manju
helm upgrade --install -n manju -f staging-values.yaml manju ./
