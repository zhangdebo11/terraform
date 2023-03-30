resource "google_container_cluster" "primary" {
  name     = "staging-manju-melonpan-cluster-standard"
  location = "asia-northeast1"
  project  = "smartcart-stagingization"

  network  = "default"
  subnetwork = "staging-to-4u"

  initial_node_count = 1
  remove_default_node_pool = true

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
    # machine_type = "e2-standard-4"
    machine_type = "e2-micro"
  }

  management {
    auto_upgrade = false
    auto_repair = true
  }
}

/*
resource "google_container_node_pool" "primary_preemptible_nodes_2" {
  name       = "pool-2"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.primary.name
  project    = "smartcart-stagingization"

  node_count = 1

  node_config {
    # machine_type = "e2-standard-4"
    machine_type = "e2-micro"
  }

  management {
    auto_upgrade = false
    auto_repair = true
  }
}
*/