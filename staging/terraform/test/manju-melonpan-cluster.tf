resource "google_container_cluster" "test" {
  name     = "staging-test"
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
    # enable_private_nodes = false
    enable_private_nodes = true
    master_ipv4_cidr_block = "172.19.10.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.88.128.0/17"
    services_ipv4_cidr_block = "10.89.0.0/22"
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
}

resource "google_container_node_pool" "test_preemptible_nodes" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.test.name
  project    = "smartcart-stagingization"

  node_count = 1

  node_config {
    machine_type = "custom-2-4096"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 100
    metadata = {
      "startup-script-url" = "gs://staging-standard-cluster/system-init-script.sh"
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  management {
    auto_upgrade = true
    auto_repair = true
  }

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = 5
  }

  
}
