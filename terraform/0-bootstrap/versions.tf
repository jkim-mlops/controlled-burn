terraform {
  required_version = ">= 1.16"

  # Bootstrap ran once with local state, because it creates the buckets that
  # hold every other stage's state. Its state then moved here, into the bucket
  # it created (terraform init -migrate-state).
  backend "gcs" {
    bucket = "jk-controlled-burn-tfstate"
    prefix = "bootstrap"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.46"
    }
  }
}

provider "google" {
  region = var.region
}
