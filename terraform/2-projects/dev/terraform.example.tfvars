# Copy to terraform.tfvars and fill in your own values.

terraform_service_account = "tf-projects-dev@example-seed.iam.gserviceaccount.com"

environment  = "dev"
project_id   = "example-dev"
project_name = "Example Dev"
region       = "us-east4"

billing_account = "XXXXXX-XXXXXX-XXXXXX"

# Alerts only; a budget never stops spending.
budget_amount = "50"
# Bucket that holds foundation-stage state (created by 0-bootstrap).
foundation_state_bucket = "example-tfstate"
