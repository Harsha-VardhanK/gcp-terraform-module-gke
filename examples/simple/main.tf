provider "google" {
  project = "my-sample-project"
  region  = "us-central1"
  zone    = "us-central1-a"
}

module "networking" {
  source = "git::https://github.com/Harsha-VardhanK/gcp-terraform-module-network.git?ref=v1.0.0"

  project_id = "my-sample-project"
  region     = "us-central1"

  vpcs = {
    main = { name = "main-vpc" }
  }

  subnets = {
    gke = {
      vpc_key   = "main"
      name      = "gke-subnet"
      region    = "us-central1"
      cidr      = "10.10.0.0/16"
      secondary = {
        pods     = "10.20.0.0/16"
        services = "10.30.0.0/20"
      }
    }
  }

  enable_nat = true
}

module "gke" {
  source  = "../../"
  project_id = "my-sample-project"
  region     = "us-central1"
  zone       = "us-central1-a"
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
