output "workload_identity_provider" {
  description = "Full resource name of the Workload Identity Pool Provider, for use in GitHub Actions workflows"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}