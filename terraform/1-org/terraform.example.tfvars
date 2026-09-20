# Copy to terraform.tfvars and fill in your own values.

org_domain                = "example.com"
terraform_service_account = "tf-org@example-seed.iam.gserviceaccount.com"

# Top-level folders. bootstrap holds the seed project, shared holds
# build-once/promote-everywhere resources, the rest are environments.
folders = ["bootstrap", "shared", "dev", "staging", "prod"]

org_admins_group     = "gcp-organization-admins@example.com"
billing_admins_group = "gcp-billing-admins@example.com"
