resource "google_container_cluster" "primary" {
  name     = "production-manju-standard-cluster"
  location = "asia-northeast1"
  project  = "smartcart-productionization"

  network  = "projects/smartcart-productionization/global/networks/raicart-4u-nat-vpc"
  subnetwork = "projects/smartcart-productionization/regions/asia-northeast1/subnetworks/subnet-northeast-1"

  initial_node_count = 1
  remove_default_node_pool = true

  private_cluster_config {
    enable_private_nodes = true
    master_ipv4_cidr_block = "172.16.10.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.80.128.0/17"
    services_ipv4_cidr_block = "10.81.0.0/22"
  }

  release_channel {
    channel = "UNSPECIFIED"
  }

  addons_config {
    dns_cache_config {
      enabled = true
    }
  }

  resource_labels = {
    "environment" = "production"
    "project" = "manju"
  }

  workload_identity_config {
    workload_pool = "smartcart-productionization.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes_1" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.primary.name
  project    = "smartcart-productionization"

  node_config {
    machine_type = "e2-custom-4-4096"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 100
    metadata = {
      "startup-script-url" = "gs://production-standard-cluster/system-init-script.sh"
      "disable-legacy-endpoints" = "true"
    }
  }

  management {
    auto_upgrade = true
    auto_repair = true
  }

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = 20
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes_2" {
  name       = "pool-2"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.primary.name
  project    = "smartcart-productionization"

  node_config {
    machine_type = "e2-custom-8-8192"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 100
    metadata = {
      "startup-script-url" = "gs://production-standard-cluster/system-init-script.sh"
      "disable-legacy-endpoints" = "true"
    }
  }

  management {
    auto_upgrade = true
    auto_repair = true
  }

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = 20
  }
}