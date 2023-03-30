resource "google_container_cluster" "primary" {
  name     = "staging-manju-melonpan-cluster-standard"
  location = "asia-northeast1"
  project  = "smartcart-stagingization"

  network  = "default"
  subnetwork = "staging-to-4u"

  initial_node_count = 1
  remove_default_node_pool = true

  node_config {
    machine_type = "e2-micro"
  }

  private_cluster_config {
    enable_private_nodes = false
    # enable_private_nodes = true
    # master_ipv4_cidr_block = "172.16.10.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.80.128.0/17"
    services_ipv4_cidr_block = "10.81.0.0/22"
  }

  release_channel {
    channel = "UNSPECIFIED"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.primary.name
  project    = "smartcart-stagingization"

  node_count = 1

  node_config {
    # machine_type = "e2-standard-4" # 4c 16GB
    machine_type = "e2-micro"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 100
    metadata = {
      "startup-script-url" = "gs://staging-standard-cluster-node-init-script/system-config.sh"
    }
  }

  management {
    auto_upgrade = false
    auto_repair = true
  }
}

# 脚本每次重启都会执行一次
# 集群自动伸缩，自动升级？