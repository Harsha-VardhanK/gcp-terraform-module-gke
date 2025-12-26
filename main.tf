# -------------------------
# GKE Cluster
# -------------------------
resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.zone

  network    = var.network
  subnetwork = var.subnet

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = var.enable_private_cluster
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  depends_on = []
}

# -------------------------
# Node Pools
# -------------------------
resource "google_container_node_pool" "node_pools" {
  for_each = { for np in var.node_pools : np.name => np }

  cluster    = google_container_cluster.gke.name
  name       = each.key
  project    = var.project_id
  location   = var.zone
  node_count = each.value.min_count

  node_config {
    preemptible  = each.value.preemptible
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  autoscaling {
    min_node_count = each.value.min_count
    max_node_count = each.value.max_count
  }
}
