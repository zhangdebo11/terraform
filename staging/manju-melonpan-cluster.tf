resource "google_compute_instance_template" "staging_manju" {
  name         = "staging-standard-cluster-manju"
  machine_type = "e2-micro"
  region       = "asia-northeast1"
  project  = "smartcart-stagingization"

  disk {
    source_image = "projects/smartcart-stagingization/global/images/ssc-common-centos7-image"
  }

  network_interface {
    network    = "default"
    subnetwork = "staging-to-4u"
  }
}

resource "google_compute_region_instance_group_manager" "staging_manju" {
  name = "staging_standard_cluster_manju"

  base_instance_name = "staging_standard_cluster_manju"
  region             = "asia-northeast1"
  project  = "smartcart-stagingization"

  version {
    instance_template  = google_compute_instance_template.staging_manju.id
  }
}

resource "google_container_cluster" "staging_manju" {
  name     = "staging-manju-melonpan-cluster-standard"
  location = "asia-northeast1"
  project  = "smartcart-stagingization"

  # network  = "default"
  # subnetwork = "staging-to-4u"

  initial_node_count       = 1

  remove_default_node_pool = true

  private_cluster_config {
    enable_private_nodes = true
    master_ipv4_cidr_block = "172.16.10.0/28"
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.80.128.0/17"
    services_ipv4_cidr_block = "10.81.0.0/22"
  }
}

resource "google_container_node_pool" "staging_manju" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.staging_manju.name
  project    = "smartcart-stagingization"

  node_count = 1

  node_config {
    # machine_type = "e2-standard-4"
    # machine_type = "e2-micro"
    node_group = google_compute_region_instance_group_manager.staging_manju.name
  }

  management {
    auto_upgrade = false
    auto_repair = true
  }
}
