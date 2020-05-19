provider "rancher2" {
  alias      = "rancher-test"
  api_url    = var.rancher_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}

resource "rancher2_cluster" "gke-import" {
  provider    = rancher2.rancher-test
  name        = "gke-master"
  description = "Created and Added through GitOps!"

  enable_cluster_monitoring =  false
}

resource "rancher2_project" "flux" {
  provider    = rancher2.rancher-test
  name = "flux-system"
  cluster_id = rancher2_cluster.gke-import.cluster_registration_token[0].cluster_id

}

resource "rancher2_project" "demo" {
  provider    = rancher2.rancher-test
  name = "demo-app"
  cluster_id = rancher2_cluster.gke-import.cluster_registration_token[0].cluster_id

}

output "cluster" {
  value = rancher2_cluster.gke-import.cluster_registration_token
}

resource "local_file" "kube_cluster" {
  filename = "command.txt"
  content  = rancher2_cluster.gke-import.cluster_registration_token[0].command
}