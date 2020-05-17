provider "google" {
  credentials = "${file("/mnt/c/Users/Chris/downloads/gke-gitops-270800-1a6b3e0f8782.json")}"
  project     = "gke-gitops-270800"
  region      = "us-central1"
}