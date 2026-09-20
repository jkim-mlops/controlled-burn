output "organization_id" {
  description = "Organization these folders live in."
  value       = data.google_organization.org.org_id
}

# Downstream stages consume these instead of looking folders up themselves,
# which keeps org-level read permission out of environment credentials.
output "folder_ids" {
  description = "Folder resource name (folders/NNN) by folder display name."
  value       = { for name, folder in google_folder.top_level : name => folder.folder_id }
}

output "folder_names" {
  description = "Full folder resource names, for parent references."
  value       = { for name, folder in google_folder.top_level : name => folder.name }
}
