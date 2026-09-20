output "project_id" {
  description = "Project downstream stages build into."
  value       = google_project.this.project_id
}

output "project_number" {
  description = "Numeric project ID, used where GCP requires it (budgets, IAM conditions)."
  value       = google_project.this.number
}

output "region" {
  description = "Default region for this environment."
  value       = var.region
}
