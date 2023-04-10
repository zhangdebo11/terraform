/*
resource "google_container_cluster" "autodeployer" {
  name     = "staging-autodeployer-cluster-standard"
  location = "asia-northeast1"
  project  = "smartcart-stagingization"

  network  = "default"
  subnetwork = "staging-to-4u"

  remove_default_node_pool = true

  private_cluster_config {
    enable_private_nodes = false
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.82.0.0/17"
    services_ipv4_cidr_block = "10.83.128.0/22"
  }
}

resource "google_container_node_pool" "autodeployer_cluster_nodes" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.autodeployer.name
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