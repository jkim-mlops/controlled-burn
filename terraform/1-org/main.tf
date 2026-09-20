data "google_organization" "org" {
  domain = var.org_domain
}

# Folders are the unit policies and permissions are applied to: a role granted
# on dev/ is inherited by every project inside it.
resource "google_folder" "top_level" {
  for_each = toset(var.folders)

  display_name        = each.value
  parent              = data.google_organization.org.name
  deletion_protection = true
}
