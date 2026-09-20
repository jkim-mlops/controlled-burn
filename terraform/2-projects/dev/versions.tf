terraform {
  required_version = ">= 1.16"

  backend "gcs" {
    bucket                      = "jk-controlled-burn-tfstate-dev"
    prefix                      = "projects"
    impersonate_service_account = "tf-projects-dev@jk-controlled-burn-seed.iam.gserviceaccount.com"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.46"
    }
  }
}

provider "google" {
  project                     = var.project_id
  region                      = var.region
  impersonate_service_account = var.terraform_service_account
}
