resource "google_container_cluster" "centrifugo" {
  name     = "staging-centrifugo-cluster-standard"
  location = "asia-northeast1"
  project  = "smartcart-stagingization"

  network  = "default"
  subnetwork = "default"

  initial_node_count = 1
  remove_default_node_pool = true

  node_config {
    machine_type = "e2-micro"
  }

  private_cluster_config {
    enable_private_nodes = false
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.63.128.0/17"
    services_ipv4_cidr_block = "10.64.0.0/22"
  }

  release_channel {
    channel = "UNSPECIFIED"
  }

  addons_config {
    dns_cache_config {
      enabled = true
    }
  }
}

resource "google_container_node_pool" "centrifugo_preemptible_nodes" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.centrifugo.name
  project    = "smartcart-stagingization"

  node_count = 0

  node_config {
    machine_type = "custom-2-2048"
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
    total_min_node_count = 0
    total_max_node_count = 100
  }
}

resource "google_container_node_pool" "centrifugo_preemptible_nodes_2" {
  name       = "pool-2"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.centrifugo.name
  project    = "smartcart-stagingization"

  node_count = 0

  node_config {
    machine_type = "custom-4-8192"
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
    total_min_node_count = 0
    total_max_node_count = 100
  }
}
