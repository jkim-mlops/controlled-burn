variable "org_domain" {
  description = "Cloud Identity domain that owns the organization."
  type        = string
}

variable "terraform_service_account" {
  description = "Stage service account this configuration impersonates."
  type        = string
}

variable "folders" {
  description = "Top-level folders under the organization."
  type        = list(string)
}

variable "org_admins_group" {
  description = "Group holding organization administration roles."
  type        = string
}

variable "billing_admins_group" {
  description = "Group holding billing administration roles."
  type        = string
}
