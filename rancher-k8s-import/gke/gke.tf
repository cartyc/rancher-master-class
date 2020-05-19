resource "google_container_cluster" "gke-cluster" {
  name                     = "master-cluster"
  network                  = "default"
  location                 = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count       = 1

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "master-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.gke-cluster.name
  node_count = 1

  node_config {
    preemptible  = false
    machine_type = "n1-standard-2"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}