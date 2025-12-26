variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "GCP zone"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "network" {
  description = "VPC network ID (from networking module)"
  type        = string
}

variable "subnet" {
  description = "Subnet ID (from networking module)"
  type        = string
}

variable "enable_private_cluster" {
  description = "Whether to enable private cluster"
  type        = bool
  default     = true
}

variable "node_pools" {
  description = "List of node pool definitions"
  type = list(object({
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = number
    preemptible  = bool
  }))
  default = []
}
