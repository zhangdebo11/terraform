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

**Note**: Please keep trigger `terraform-standardcluster` manual.

**Note**: Better NOT to use trigger `terraform-standardcluster` to modify clusters.

# 3. Migrate Manju cluster

## 3.1 Migrate Metrics-Sidecar-Injector

- Delete mutatingwebhookconfiguration `metrics-sidecar-webhook-config` in ALL clusters.
- Uninstall Metrics-Sidecar-Injector in the old Manju cluster.
- Modify Cloud-Build trigger `metrics-sidecar-injector-staging-deploy`, change the `_cluster` value and run it to install Metrics-Sidecar-Injector in the new Manju cluster.
- After the new Metrics-Sidecar-Injector service is ready, create mutatingwebhookconfiguration `metrics-sidecar-webhook-config` in ALL clusters.


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


## 3.5 Migrate Prometheus

## 3.6 Migrate Toxiproxy

# 4. Migrate Yakiimo cluster

## 4.1 Migrate Yakiimo

## 4.2 Migrate Prometheus

## 4.3 Create Metrics-Sidecar webhook configuration


# 5. Migrate Centrifugo cluster

## 5.1 Migrate Centrifugo



## 5.2 Migrate Prometheus

## 5.3 Create Metrics-Sidecar webhook configuration

## 5.4 Migrate Toxiproxy

# 3. prepare prometheus

安装前先创建 gcp_service_account ，并赋予 monitoring metric writer 角色

# 4. 关闭 metrics-sidecar-webhook

删除所有集群的 mutatingwebhookconfiguration `metrics-sidecar-webhook-config`。

```sh
kubectl delete mutatingwebhookconfiguration metrics-sidecar-webhook-config
```


# 6. 安装新的metrics-sidecar

修改 trigger `metrics-sidecar-injector-staging-deploy` 中的变量 `_CLUSTER_` 值。执行trigger。

在所有集群中创建 mutatingwebhookconfiguration `metrics-sidecar-webhook-config`。


# 7. migrate toxiproxy

# 8. migrate argocd
