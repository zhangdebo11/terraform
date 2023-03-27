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
kubectl create ns monitoring
helm upgrade --install -n monitoring -f staging-values.yaml prometheus ./

# install manju
kubectl create ns manju
helm upgrade --install -n manju -f staging-values.yaml manju ./
