locals {
  # Roles each stage needs on the organization.
  org_roles = {
    # organizationAdmin is what lets 1-org manage org-level IAM in code; it is
    # the most powerful role here, so only gcp-organization-admins@ may
    # impersonate tf-org, and the account has no keys.
    # Mirrors granular_sa_org_level_roles["org"] in terraform-example-foundation.
    "tf-org" = [
      "roles/resourcemanager.folderAdmin",
      "roles/resourcemanager.organizationAdmin",
      "roles/resourcemanager.organizationViewer",
      "roles/orgpolicy.policyAdmin",
    ]
    "tf-projects-dev" = ["roles/billing.user"]
  }

  # Every environment-scoped stage is granted on its own environment folder
  # only, so no credential can reach another environment. Adding staging or
  # prod means another service account per stage, not a wider grant.
  stage_folder_roles = {
    "tf-projects-dev" = {
      folder = "dev"
      roles = [
        "roles/resourcemanager.projectCreator",
        "roles/resourcemanager.projectIamAdmin",
        "roles/serviceusage.serviceUsageAdmin",
      ]
    }
    "tf-network-dev" = {
      folder = "dev"
      roles = [
        "roles/compute.networkAdmin",
        "roles/compute.securityAdmin",
        "roles/serviceusage.serviceUsageAdmin",
      ]
    }
    "tf-cluster-dev" = {
      folder = "dev"
      roles = [
        "roles/container.admin",
        "roles/artifactregistry.admin",
        "roles/iam.serviceAccountAdmin",
        "roles/iam.serviceAccountUser",
        "roles/iam.workloadIdentityPoolAdmin",
        "roles/resourcemanager.projectIamAdmin",
        "roles/serviceusage.serviceUsageAdmin",
      ]
    }
    "tf-platform-dev" = {
      # container.admin maps to cluster-admin in GKE, which Argo CD's install needs.
      folder = "dev"
      roles  = ["roles/container.admin"]
    }
  }

  # Flattened {stage, scope, role} tuples, keyed for for_each.
  org_bindings = merge([
    for stage, roles in local.org_roles : {
      for role in roles : "${stage}/${role}" => { stage = stage, role = role }
    }
  ]...)

  stage_folder_bindings = merge([
    for stage, cfg in local.stage_folder_roles : {
      for role in cfg.roles :
      "${stage}/${cfg.folder}/${role}" => { stage = stage, folder = cfg.folder, role = role }
    }
  ]...)

  # Each stage owns objects in its own state bucket; environment stages also read
  # the foundation bucket to pull upstream outputs via terraform_remote_state.
  state_read_bindings = {
    for stage, cfg in local.stages : stage => cfg.state
    if cfg.state != "foundation"
  }
}

resource "google_organization_iam_member" "stage" {
  for_each = local.org_bindings

  org_id = data.google_organization.org.org_id
  role   = each.value.role
  member = google_service_account.stage[each.value.stage].member
}

resource "google_folder_iam_member" "env_stage" {
  for_each = local.stage_folder_bindings

  folder = data.google_active_folder.folders[each.value.folder].name
  role   = each.value.role
  member = google_service_account.stage[each.value.stage].member
}

resource "google_billing_account_iam_member" "projects_stage_budgets" {
  billing_account_id = var.billing_account
  role               = "roles/billing.costsManager"
  member             = google_service_account.stage["tf-projects-dev"].member
}

resource "google_storage_bucket_iam_member" "stage_own_state" {
  for_each = local.stages

  bucket = google_storage_bucket.state[each.value.state].name
  role   = "roles/storage.objectAdmin"
  member = google_service_account.stage[each.key].member
}

resource "google_storage_bucket_iam_member" "stage_read_foundation_state" {
  for_each = local.state_read_bindings

  bucket = google_storage_bucket.state["foundation"].name
  role   = "roles/storage.objectViewer"
  member = google_service_account.stage[each.key].member
}

# Humans in the org-admins group impersonate stage service accounts instead of
# holding these permissions themselves, and no service account keys exist.
resource "google_service_account_iam_member" "impersonation" {
  for_each = local.stages

  service_account_id = google_service_account.stage[each.key].name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${var.org_admins_group}"
}
