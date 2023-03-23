terraform {
  backend "gcs" {
    bucket = var.bucket_name
    prefix = var.bucket_prefix
  }
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.cluster_location
  project  = var.cluster_project

  network  = var.cluster_network
  subnetwork = var.cluster_subnetwork

  node_pool {
    node_count = var.node_count
    node_config {
      machine_type = var.machine_type
    }
    management {
      auto_upgrade = false
      auto_repair = true
    }
  }

  private_cluster_config {
    enable_private_nodes = true
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = var.pod_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }
}
