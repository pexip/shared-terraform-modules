# Create the Workload Identity Pool
resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "${var.project_id}-pool"
  display_name              = "GHA Pool ${var.project_id}"
}

# Create the OIDC provider for GitHub within the pool
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "${var.project_id}-provider"
  display_name                       = "GHA Provider ${var.project_id}"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  # Map GitHub OIDC token claims -> attributes you can use in IAM bindings
  # See https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  # Required: attribute condition must reference mapped claims
  attribute_condition = "assertion.repository == '${var.github_repository}'"
}

# Bind pool identities to allow impersonation of the SA, restricted to a single repository
resource "google_service_account_iam_member" "wif_repo_impersonation" {
  service_account_id = var.service_account_id
  role               = "roles/iam.workloadIdentityUser"
  # This locks it to just the one repo owner/repo
  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/${var.github_repository}"
}
