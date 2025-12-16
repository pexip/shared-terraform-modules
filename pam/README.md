# PAM (Privileged Access Manager) Module

A Terraform module for creating Google Cloud Privileged Access Manager (PAM) entitlements for just-in-time access control.

## Features

- Just-in-time privileged access to GCP resources
- Support for project, folder, and organization-level entitlements
- Optional approval workflow with multiple approvers
- Configurable request duration and justification requirements
- Email notifications for approval requests
- Automatic entitlement ID generation from role names

## Usage

### Basic entitlement without approval workflow

```hcl
module "pam_entitlement" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//pam"

  parent_id     = "projects/my-project-id"
  parent_type   = "Project"
  role          = "roles/compute.admin"
  eligible_users = [
    "user:john.doe@pexip.com",
    "group:devops-team@pexip.com"
  ]
}
```

### Entitlement with approval workflow

```hcl
module "pam_entitlement_with_approval" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//pam"

  parent_id                    = "folders/123456789"
  parent_type                  = "Folder"
  role                         = "roles/resourcemanager.folderAdmin"
  eligible_users               = [
    "user:engineer@pexip.com"
  ]
  approvers                    = [
    "user:manager@pexip.com",
    "group:security-team@pexip.com"
  ]
  number_of_required_approvers = 1
  require_justification        = true
  notifiers                    = [
    "manager@pexip.com",
    "security-team@pexip.com"
  ]
}
```

## Variables

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `parent_id` | string | yes | - | The ID of the parent resource where PAM entitlements will be created. Format: `projects/{id}`, `folders/{id}`, or `organizations/{id}` |
| `parent_type` | string | yes | - | The type of the parent resource. Must be one of: `Project`, `Folder`, or `Organization` |
| `role` | string | yes | - | The IAM role to be assigned via PAM. Format: `roles/{roleName}` |
| `eligible_users` | list(string) | yes | - | List of principals eligible for the PAM entitlement. Format: `user:{email}`, `group:{email}`, or `serviceAccount:{email}` |
| `approvers` | list(string) | no | [] | List of principals that can approve requests. Format: `user:{email}`, `group:{email}`, or `serviceAccount:{email}`. If empty, no approval workflow is created |
| `number_of_required_approvers` | number | no | 0 | The number of approvers required to approve a request |
| `require_justification` | bool | no | false | Whether approver justification is required when approving a request |
| `notifiers` | list(string) | no | [] | List of email addresses to notify when an approval is requested |

## Important Notes

### Principal Format
All principals (eligible_users and approvers) must be in GCP format:
- Users: `user:john.doe@pexip.com`
- Groups: `group:team@pexip.com`
- Service Accounts: `serviceAccount:my-sa@project.iam.gserviceaccount.com`

### Approval Workflow
The approval workflow is only created when the `approvers` list is not empty. If you want self-service access without approval, simply omit the `approvers` variable.

### Request Duration
All entitlements have a maximum request duration of 4 hours (14400 seconds). Users must re-request access after this period expires.

### Entitlement ID
The entitlement ID is automatically generated from the role name with the format `pam-{role-name}` (limited to 63 characters). For example, `roles/compute.admin` becomes `pam-compute-admin`.

## Outputs

This module does not currently expose any outputs.

## Example Scenarios

### Scenario 1: Emergency Access for On-Call Engineers
```hcl
module "oncall_compute_admin" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//pam"

  parent_id      = "projects/production-project"
  parent_type    = "Project"
  role           = "roles/compute.admin"
  eligible_users = ["group:oncall-engineers@pexip.com"]
}
```

### Scenario 2: Audited Access with Multiple Approvers
```hcl
module "org_admin_access" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//pam"

  parent_id                    = "organizations/123456789"
  parent_type                  = "Organization"
  role                         = "roles/resourcemanager.organizationAdmin"
  eligible_users               = ["user:senior-engineer@pexip.com"]
  approvers                    = [
    "user:cto@pexip.com",
    "user:security-lead@pexip.com"
  ]
  number_of_required_approvers = 2
  require_justification        = true
  notifiers                    = ["security-team@pexip.com"]
}
```

## Module Versioning

When using this module, it's recommended to reference a specific git tag or commit SHA:

```hcl
module "pam_entitlement" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//pam?ref=v1.0.0"
  # ... variables
}
```
