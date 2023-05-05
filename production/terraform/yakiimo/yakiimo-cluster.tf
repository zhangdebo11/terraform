resource "google_container_cluster" "yakiimo" {
  name     = "production-yakiimo-cluster-standard"
  location = "asia-northeast1"
  project  = "smartcart-productionization"

  network  = "projects/smartcart-stagingization/global/networks/default"
  subnetwork = "projects/smartcart-stagingization/regions/asia-northeast1/subnetworks/staging-to-4u"

  initial_node_count = 1
  remove_default_node_pool = true

  private_cluster_config {
    enable_private_nodes = false
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.16.0.0/17"
    services_ipv4_cidr_block = "10.16.128.0/22"
  }

  release_channel {
    channel = "UNSPECIFIED"
  }

  addons_config {
    dns_cache_config {
      enabled = true
    }
  }

  resource_labels = {
    "mesh_id" = "proj-495370126123"
  }

  workload_identity_config {
    workload_pool = "smartcart-productionization.svc.id.goog"
  }
}


resource "google_container_node_pool" "yakiimo_preemptible_nodes_1" {
  name       = "pool-1"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.yakiimo.name
  project    = "smartcart-productionization"

  node_config {
    machine_type = "custom-2-2048"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 100
    metadata = {
      "startup-script-url" = "gs://production-standard-cluster/system-init-script.sh"
      "disable-legacy-endpoints" = "true"
    }
  }

  management {
    auto_upgrade = true
    auto_repair = true
  }

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = 20
  }
}


resource "google_container_node_pool" "yakiimo_preemptible_nodes_2" {
  name       = "pool-2"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.yakiimo.name
  project    = "smartcart-productionization"

  node_config {
    machine_type = "custom-6-6144"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 100
    metadata = {
      "startup-script-url" = "gs://production-standard-cluster/system-init-script.sh"
      "disable-legacy-endpoints" = "true"
    }
  }

  management {
    auto_upgrade = true
    auto_repair = true
  }

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = 20
  }
}

resource "google_container_node_pool" "yakiimo_preemptible_nodes_3" {
  name       = "pool-3"
  location   = "asia-northeast1"
  cluster    = google_container_cluster.yakiimo.name
  project    = "smartcart-productionization"

  node_config {
    machine_type = "custom-4-4096"
    image_type   = "UBUNTU_CONTAINERD"
    disk_size_gb = 100
    metadata = {
      "startup-script-url" = "gs://production-standard-cluster/system-init-script.sh"
      "disable-legacy-endpoints" = "true"
    }
  }

  management {
    auto_upgrade = true
    auto_repair = true
  }

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = 20
  }
}