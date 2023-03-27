# create Cloud Storage bucket

```shell
gsutil mb gs://smartcart-stagingization-tfstate
gsutil versioning set on gs://smartcart-stagingization-tfstate
```

# install prometheus
kubectl create ns monitoring
helm upgrade --install -n monitoring -f staging-values.yaml prometheus ./
