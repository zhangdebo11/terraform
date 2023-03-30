/*
resource "google_container_cluster" "centrifugo" {
  name     = "staging-centrifugo-cluster-standard"
  location = "asia-northeast1"
  project  = "smartcart-stagingization"

  network  = "default"
  subnetwork = "default"

  remove_default_node_pool = true

  private_cluster_config {
    enable_private_nodes = false
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.84.128.0/17"
    services_ipv4_cidr_block = "10.85.0.0/22"
  }
}

resource "google_container_node_pool" "centrifugo_cluster_nodes" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.centrifugo.name
  project    = "smartcart-stagingization"

  node_count = 1

  node_config {
    machine_type = "e2-micro"
    # machine_type = "e2-standard-4"
  }

  management {
    auto_upgrade = false
    auto_repair = true
  }
}
*/