resource "google_container_cluster" "test" {
  name     = "staging-test"
  location = "asia-northeast1"
  project  = "smartcart-stagingization"

  network  = "default"
  subnetwork = "default"

  initial_node_count = 1
  remove_default_node_pool = true

  private_cluster_config {
    enable_private_nodes = true
    master_ipv4_cidr_block = "172.16.11.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.82.128.0/17"
    services_ipv4_cidr_block = "10.83.0.0/22"
  }

  release_channel {
    channel = "UNSPECIFIED"
  }

  addons_config {
    dns_cache_config {
      enabled = true
    }
  }

  workload_identity_config {
    workload_pool = "smartcart-stagingization.svc.id.goog"
  }

  cluster_autoscaling {
    enabled = true
    resource_limits {
      {
        resource_type = "cpu"
        minimum = 1
        maximum = 16
      },
      {
        resource_type = "memory"
        minimum = 1
        maximum = 64
      }
    }
  }
}

resource "google_container_node_pool" "test_nodes" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.test.name
  project    = "smartcart-stagingization"

  node_config {
    machine_type = "e2-custom-2-4096"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 20
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
  }

  management {
    auto_upgrade = true
    auto_repair = true
  }

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = 10
  }
}
