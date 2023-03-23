resource "google_container_cluster" "primary" {
  name     = "standard-cluster-terraform"
  location = "asia-northeast1"
  project  = "smartcart-stagingization"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 3
  node_config {
    machine_type = "e2-medium"
    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
}
