# Copy to terraform.tfvars and fill in your own values.
# terraform.tfvars is gitignored: these are identifiers, not secrets, but they
# map out an organization and don't belong in a public repo.

# Cloud Identity domain that owns the organization.
org_domain = "example.com"

# Billing account the seed project bills to, and where budgets are created.
# Find it with: gcloud billing accounts list
billing_account = "XXXXXX-XXXXXX-XXXXXX"

# Project holding Terraform state, stage service accounts and CI identity.
# The prefix (everything before -seed) also names the state buckets.
seed_project_id = "example-seed"

# Region for the state buckets. Keep it close to where workloads run.
region = "us-east4"

# Environment folders, in promotion order. Each gets its own state bucket.
environments = ["dev", "staging", "prod"]

# Group whose members may impersonate every stage service account.
org_admins_group = "gcp-organization-admins@example.com"
