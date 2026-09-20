locals {
  # Org-level roles are granted to groups only: people join and leave groups,
  # while the IAM policy itself stays still. Stage service accounts get their
  # own org roles in 0-bootstrap.
  group_org_roles = {
    (var.org_admins_group) = [
      "roles/resourcemanager.organizationAdmin",
      "roles/resourcemanager.folderAdmin",
      "roles/resourcemanager.projectCreator",
      "roles/orgpolicy.policyAdmin",
      "roles/billing.user",
    ]
    (var.billing_admins_group) = [
      "roles/billing.admin",
      "roles/billing.creator",
      "roles/resourcemanager.organizationViewer",
    ]
  }

  group_org_bindings = merge([
    for group, roles in local.group_org_roles : {
      for role in roles : "${group}/${role}" => { group = group, role = role }
    }
  ]...)
}

resource "google_organization_iam_member" "groups" {
  for_each = local.group_org_bindings

  org_id = data.google_organization.org.org_id
  role   = each.value.role
  member = "group:${each.value.group}"
}
