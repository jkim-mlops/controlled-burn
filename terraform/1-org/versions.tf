terraform {
  required_version = ">= 1.16"

  backend "gcs" {
    bucket                      = "jk-controlled-burn-tfstate"
    prefix                      = "org"
    impersonate_service_account = "tf-org@jk-controlled-burn-seed.iam.gserviceaccount.com"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.46"
    }
  }
}

provider "google" {
  impersonate_service_account = var.terraform_service_account
}
