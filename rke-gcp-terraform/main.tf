terraform {
  backend "gcs" {
    bucket  = "tf-state-prod"
    prefix  = "terraform/state"
  }
}

module "infra" {
  source = "./infra"
  
}
