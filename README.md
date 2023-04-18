# 1. Prepare a Cloud-Storage bucket

Create a Cloud-Storage bucket, it will be used to:
- storage OS init script
- storage terraform state files

```sh
gsutil mb gs://staging-standard-cluster
gsutil versioning set on gs://staging-standard-cluster
```

Upload OS init script `system-init-script.sh` to this bucket.

# 2. Deploy standard clusters

Check `cloudbuild.yaml` file content and run Cloud-Build trigger `terraform-standardcluster` to create standard clusters.

# 3. Migrate applications in Manju cluster

## 3.1 Migrate Metrics-Sidecar-Injector

- Delete mutatingwebhookconfiguration `metrics-sidecar-webhook-config` in ALL clusters.
- Uninstall Metrics-Sidecar-Injector in the old Manju cluster.
- Modify Cloud-Build trigger `metrics-sidecar-injector-staging-deploy`, change the `_cluster` value and run it to install Metrics-Sidecar-Injector in the new Manju cluster.
- Create mutatingwebhookconfiguration `metrics-sidecar-webhook-config` in ALL the new clusters. The helm chart is stored in code repository `metrics-sidecar-injector`.

## 3.2 Install Proxysql in the new cluster

This step must be before `Migrate applications`.

- Create namespace `proxysql` in the new cluster.
- Install Proxysql in the new cluster using helm.

## 3.3 Install Mongos in the new cluster

This step must be before `Migrate applications`.

- Create namespace `mongos` in the new cluster.
- Create an application named `mongos` in ArgoCD, using the new cluster, and sync it.
- Modify the `cloudbuild.yaml` file in code repository `docker-mongos`, using ArgoCD instead of Gke-Deploy.

## 3.4 Migrate applications

Migrate following applications one by one:
- Manju
- Gulab
- Monaka
- Macaron
- Melonpan

For each application, the migration should follow these steps:
- Uninstall application in the old cluster.
- Create namespace in the new cluster.
- Modify ArgoCD application, change the `cluster` value, then sync it.
- Modify Cloud-Build trigger, change the `_cluster` value.
- Apply Armor policy to the new backend service target.


# 4. Migrate Yakiimo

- Uninstall application in the old cluster.
- Create namespace in the new cluster.
- Modify ArgoCD application, change the `cluster` value, then sync it.
- Modify Cloud-Build trigger, change the `_cluster` value.
- Apply Armor policy to the new backend service target.

# 5. Migrate Centrifugo cluster

- Uninstall application in the old cluster.
- Create namespace in the new cluster.
- Modify Cloud-Build trigger, change the `_cluster` value, then run it.


# 6. Common things

## Prometheus

Before installing Prometheus, please make sure that a required GCP service account with role `Monitoring Metric Writer` is ready.

Install Prometheus in all the new clusters using helm. The helm chart is stored in code repository `manju-helm`.

## Toxiproxy

- Uninstall Toxiproxy in the old clusters.
- Modify Cloud-Build trigger `toxiproxy-deploy`, change `_CLUSTER_1` and `_CLUSTER_2` value, then run it to install Toxiproxy in the new clusters.
