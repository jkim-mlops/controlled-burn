data "google_organization" "org" {
  domain = var.org_domain
}

# Folder IDs are looked up by name so no numeric IDs appear in this code.
data "google_active_folder" "folders" {
  for_each     = toset(local.managed_folders)
  display_name = each.value
  parent       = data.google_organization.org.name
}

locals {
  prefix = trimsuffix(var.seed_project_id, "-seed")

  # Folders whose projects tf-projects is allowed to create and configure.
  managed_folders = concat(["bootstrap", "shared"], var.environments)

  # One state bucket for the foundation stages, one per environment. Splitting
  # them means a dev credential cannot read or corrupt prod state.
  state_buckets = merge(
    { foundation = "${local.prefix}-tfstate" },
    { for env in var.environments : env => "${local.prefix}-tfstate-${env}" },
  )

  # Every Terraform stage runs as its own service account in the seed project,
  # so tearing down an environment never removes the identity that manages it.
  stages = {
    "tf-org"          = { display_name = "Terraform org stage", state = "foundation" }
    "tf-projects"     = { display_name = "Terraform projects stage", state = "foundation" }
    "tf-network-dev"  = { display_name = "Terraform network dev stage", state = "dev" }
    "tf-cluster-dev"  = { display_name = "Terraform cluster dev stage", state = "dev" }
    "tf-platform-dev" = { display_name = "Terraform platform dev stage", state = "dev" }
  }

  seed_apis = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "storage.googleapis.com",
    "sts.googleapis.com",
  ]
}

resource "google_project" "seed" {
  name            = "Controlled Burn Seed"
  project_id      = var.seed_project_id
  folder_id       = data.google_active_folder.folders["bootstrap"].id
  billing_account = var.billing_account
}

resource "google_project_service" "seed" {
  for_each = toset(local.seed_apis)

  project            = google_project.seed.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "state" {
  for_each = local.state_buckets

  name     = each.value
  project  = google_project.seed.project_id
  location = var.region

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }

  depends_on = [google_project_service.seed]
}

resource "google_service_account" "stage" {
  for_each = local.stages

  account_id   = each.key
  display_name = each.value.display_name
  project      = google_project.seed.project_id

  depends_on = [google_project_service.seed]
}
