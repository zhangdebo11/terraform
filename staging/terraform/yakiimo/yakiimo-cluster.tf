resource "google_container_cluster" "yakiimo" {
  name     = "staging-yakiimo-cluster-standard"
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
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.16.0.0/17"
    services_ipv4_cidr_block = "10.16.128.0/22"
  }

  default_snat_status {
    disabled = false
  }


  release_channel {
    channel = "UNSPECIFIED"
  }

  addons_config {
    dns_cache_config {
      enabled = true
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
    network_policy_config {
      disabled = true
    }
  }

  binary_authorization {
    enabled = false
  }

  cluster_autoscaling {
    enabled = false
  }

}

resource "google_container_node_pool" "yakiimo_preemptible_nodes" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.yakiimo.name
  project    = "smartcart-stagingization"

  node_count = 1

  node_config {
    machine_type = "custom-4-4096"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 100
    metadata = {
      "startup-script-url" = "gs://staging-standard-cluster/system-init-script.sh"
    }
  }

  management {
    auto_upgrade = true
    auto_repair = true
  }

  autoscaling {
    total_min_node_count = 1
    total_max_node_count = 11
  }
}
