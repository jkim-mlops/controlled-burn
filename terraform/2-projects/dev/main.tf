# Upstream stages publish what downstream stages need. Reading 1-org's outputs
# keeps org-level read permission out of this environment's credential, and
# makes the stage dependency explicit: 1-org must be applied first.
data "terraform_remote_state" "org" {
  backend = "gcs"

  config = {
    bucket                      = var.foundation_state_bucket
    prefix                      = "org"
    impersonate_service_account = var.terraform_service_account
  }
}

resource "google_project" "this" {
  name            = var.project_name
  project_id      = var.project_id
  folder_id       = data.terraform_remote_state.org.outputs.folder_ids[var.environment]
  billing_account = var.billing_account
}

# APIs belong with the project that owns them: a stage further down the line
# cannot look up whether a service is enabled, so it must already be on.
resource "google_project_service" "apis" {
  for_each = toset([
    "billingbudgets.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
  ])

  project            = google_project.this.project_id
  service            = each.value
  disable_on_destroy = false
}
