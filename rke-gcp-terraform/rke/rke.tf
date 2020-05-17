resource "rke_cluster" "rancher_cluster" {
  cluster_name = "quickstart-rancher-server"

  nodes {
    address          = var.node_public_ip
    internal_address = var.node_internal_ip
    user             = "terraform"
    role             = ["controlplane", "etcd", "worker"]
    ssh_key          = file("/home/carty/.ssh/gcloud")
  }

  kubernetes_version = "v1.17.5-rancher1-1"
}

resource "local_file" "kube_cluster_yaml" {
  filename = "kube_config_cluster.yml"
  content  = rke_cluster.rancher_cluster.kube_config_yaml
}