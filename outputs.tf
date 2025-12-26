output "cluster_name" {
  value       = google_container_cluster.gke.name
  description = "GKE cluster name"
}

output "endpoint" {
  value       = google_container_cluster.gke.endpoint
  description = "GKE cluster endpoint"
}

output "node_pools" {
  value       = { for k, v in google_container_node_pool.node_pools : k => v.name }
  description = "Map of node pool names"
}
