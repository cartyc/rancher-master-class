provider "google" {
  credentials = var.credentials
  project     = "gke-gitops-270800"
  region      = "us-central1"
}