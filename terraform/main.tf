terraform {
  required_version = ">= 1.16"

  backend "gcs" {
    bucket                      = "jk-controlled-burn-dev-tfstate"
    prefix                      = "dev"
    impersonate_service_account = "terraform@jk-controlled-burn-dev.iam.gserviceaccount.com"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.3"
    }
  }
}

provider "google" {
  project                     = "jk-controlled-burn-dev"
  region                      = "us-east4"
  impersonate_service_account = "terraform@jk-controlled-burn-dev.iam.gserviceaccount.com"
}
