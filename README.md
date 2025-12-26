Terraform GKE Module (GCP)

This Terraform module creates a Google Kubernetes Engine (GKE) Standard cluster on Google Cloud Platform.
It is designed to be production-ready, reusable across projects, and compatible with private clusters, multiple node pools, and Spot (preemptible) nodes.

This module is intended to be used together with a networking module that provides the VPC, subnet, and secondary IP ranges.

Features

Creates a GKE Standard cluster

Supports private GKE clusters

Supports multiple node pools

Supports Spot (preemptible) node pools

Works with custom VPC and subnet

Designed for multi-project, CI/CD-ready Terraform usage

Registry-style module structure

Requirements
Name	Version
Terraform	>= 1.5.0
Google Provider	~> 6.0
Inputs
Required Inputs
Name	Description	Type
project_id	GCP project ID	string
region	GCP region	string
zone	GCP zone	string
cluster_name	Name of the GKE cluster	string
network	VPC network ID	string
subnet	Subnet ID	string
Optional Inputs
Name	Description	Type	Default
enable_private_cluster	Enable private GKE cluster	bool	true
node_pools	List of node pool definitions	list(object)	[]
node_pools Object Definition
node_pools = [
  {
    name         = string
    machine_type = string
    min_count    = number
    max_count    = number
    disk_size_gb = number
    preemptible  = bool
  }
]

Outputs
Name	Description
cluster_name	Name of the GKE cluster
endpoint	GKE cluster API endpoint
node_pools	Map of node pool names
Example Usage
Basic Example
module "gke" {
  source = "git::https://github.com/Harsha-VardhanK/gcp-terraform-module-gke.git?ref=v1.0.0"

  project_id   = "my-sample-project"
  region       = "us-central1"
  zone         = "us-central1-a"
  cluster_name = "demo-cluster"

  network = module.networking.vpcs["main"]
  subnet  = module.networking.subnets["gke"]

  node_pools = [
    {
      name         = "standard-pool"
      machine_type = "e2-medium"
      min_count    = 1
      max_count    = 3
      disk_size_gb = 50
      preemptible  = false
    },
    {
      name         = "spot-pool"
      machine_type = "e2-medium"
      min_count    = 0
      max_count    = 2
      disk_size_gb = 50
      preemptible  = true
    }
  ]
}

Private GKE Cluster Notes

When enable_private_cluster = true:

GKE nodes do not have public IPs

Outbound internet access requires Cloud NAT

Ensure your networking module enables Cloud NAT for private clusters