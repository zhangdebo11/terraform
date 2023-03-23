resource "google_container_cluster" "primary" {
  name     = "staging-manju-melonpan-cluster-standard"
  location = "asia-northeast1"
  project  = "smartcart-stagingization"

  network  = "default"
  subnetwork = "staging-to-4u"

  initial_node_count       = 1

  node_config {
    # machine_type = "e2-standard-4"
    machine_type = "e2-micro"
  }

  cluster_autoscaling {
    auto_provisioning_defaults {
      management {
        auto_upgrade = false
      }
    }
  }

  private_cluster_config {
    enable_private_nodes = true
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.90.128.0/17"
    services_ipv4_cidr_block = "10.91.0.0/22"
  }
}
