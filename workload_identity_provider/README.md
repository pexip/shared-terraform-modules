# Workload Identity Provider Module

A Terraform module for configuring GCP Workload Identity Federation for GitHub Actions, enabling keyless authentication without long-lived service account keys.

## Features

- Keyless authentication from GitHub Actions to GCP (no service account keys required)
- Workload Identity Pool and OIDC provider scoped to a single GitHub repository
- Restricts impersonation to a specific repository via attribute conditions
- Maps GitHub OIDC token claims to GCP attributes for fine-grained access control

## Usage

```hcl
module "workload_identity" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//workload_identity_provider"

  project_id         = "my-gcp-project"
  github_repository  = "pexip/my-repo"
  service_account_id = "projects/my-gcp-project/serviceAccounts/my-sa@my-gcp-project.iam.gserviceaccount.com"
}
```

## Variables

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `project_id` | string | yes | - | GCP project ID where the Workload Identity Pool will be created |
| `github_repository` | string | yes | - | GitHub repository in `<org>/<repo>` format that is allowed to authenticate |
| `service_account_id` | string | yes | - | Full resource ID of the service account to allow impersonation of. Format: `projects/{project}/serviceAccounts/{email}` |

## Outputs

| Name | Description |
|------|-------------|
| `workload_identity_provider` | Full resource name of the Workload Identity Pool Provider, used in GitHub Actions workflows |

## Important Notes

### Resource Naming
The Workload Identity Pool and provider IDs are auto-derived from `project_id`:
- Pool ID: `<project_id>-pool`
- Provider ID: `<project_id>-provider`

### GitHub Actions Configuration
Use the `workload_identity_provider` output in your GitHub Actions workflow to configure authentication:

```yaml
- uses: google-github-actions/auth@v2
  with:
    workload_identity_provider: "<value of workload_identity_provider output>"
    service_account: my-sa@my-gcp-project.iam.gserviceaccount.com
```

Retrieve the provider name from the Terraform output:

```bash
terraform output -raw workload_identity_provider
```

### Repository Restriction
Access is restricted to the exact repository specified in `github_repository` via an attribute condition on the OIDC token (`assertion.repository == '<org>/<repo>'`). Any other repository — including repositories with a name that is a prefix of the specified one — cannot impersonate the service account.

## Module Versioning

When using this module, it's recommended to reference a specific git tag or commit SHA:

```hcl
module "workload_identity" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//workload_identity_provider?ref=v1.0.0"
  # ... variables
}
```
