variable "org_domain" {
  description = "Cloud Identity domain that owns the organization."
  type        = string
}

variable "billing_account" {
  description = "Billing account the seed project bills to, and where budgets are created."
  type        = string
}

variable "seed_project_id" {
  description = "Project that holds Terraform state, stage service accounts and CI identity."
  type        = string
}

variable "region" {
  description = "Default region for the state buckets."
  type        = string
}

variable "environments" {
  description = "Environment folder names, in promotion order."
  type        = list(string)
}

variable "org_admins_group" {
  description = "Group allowed to impersonate every stage service account."
  type        = string
}
