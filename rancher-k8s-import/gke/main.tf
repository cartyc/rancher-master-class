terraform {
  backend "gcs" {
    bucket  = "k8s-dev"
    prefix  = "terraform/dev-state"
  }
}