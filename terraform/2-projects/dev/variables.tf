variable "foundation_state_bucket" {
  description = "Bucket holding foundation stage state, read for upstream outputs."
  type        = string
}

variable "terraform_service_account" {
  description = "Stage service account this configuration impersonates."
  type        = string
}

variable "environment" {
  description = "Environment folder this project lives in."
  type        = string
}

variable "project_id" {
  description = "Project this stage manages."
  type        = string
}

variable "project_name" {
  description = "Display name of the project."
  type        = string
}

variable "billing_account" {
  description = "Billing account the project is linked to."
  type        = string
}

variable "region" {
  description = "Default region for resources in this project."
  type        = string
}

variable "budget_amount" {
  description = "Monthly budget in whole currency units, alerting only."
  type        = string
}
