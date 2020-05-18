terraform {
  backend "gcs" {
    bucket  = "k8s-import"
    prefix  = "terraform/dev-state"
  }
}