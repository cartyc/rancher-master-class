provider "rancher2" {
  alias      = "rancher-test"
  api_url    = var.rancher_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}

resource "rancher2_cluster" "gke-import" {
  provider    = rancher2.rancher-test
  name        = "gke-import-dev"
  description = "Foo rancher2 imported cluster"

  enable_cluster_monitoring = false
}

output "cluster" {
  value = rancher2_cluster.gke-import.cluster_registration_token
}

resource "local_file" "kube_cluster" {
  filename = "command.txt"
  content  = rancher2_cluster.gke-import.cluster_registration_token[0].command
}