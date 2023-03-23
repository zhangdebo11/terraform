cluster_name = "staging-manju-melonpan-cluster-standard"
cluster_location = "asia-northeast1"
cluster_project = "smartcart-stagingization"

cluster_network = "default"
cluster_subnetwork = "staging-to-4u"

node_count = 1
machine_type = "e2-micro"

master_ipv4_cidr_block = "172.16.10.0/28"
pod_ipv4_cidr_block = "10.80.128.0/17"
services_ipv4_cidr_block = "10.81.0.0/22"
