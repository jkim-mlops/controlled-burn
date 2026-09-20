output "seed_project_id" {
  description = "Project holding Terraform state and stage service accounts."
  value       = google_project.seed.project_id
}

output "state_buckets" {
  description = "State bucket per scope: foundation stages and each environment."
  value       = { for scope, bucket in google_storage_bucket.state : scope => bucket.name }
}

output "stage_service_accounts" {
  description = "Service account email each Terraform stage impersonates."
  value       = { for stage, sa in google_service_account.stage : stage => sa.email }
}

output "organization_id" {
  description = "Organization the foundation is built in."
  value       = data.google_organization.org.org_id
}
