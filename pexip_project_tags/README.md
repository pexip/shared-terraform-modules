# Pexip Project Tags Module

A Terraform module for generating standardized labels/tags for Pexip projects in GCP and Azure.

## Features

- Standardized tagging across all Pexip projects
- Validation of team, product, and environment values
- Support for custom additional tags
- Ensures either owner or team is specified

## Usage

```hcl
module "project_tags" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//pexip_project_tags"

  team        = "vcops"
  owner       = "john.doe@pexip.com"
  product     = "shared"
  environment = "prod"
  managed_by  = "pexip/infrastructure-repo"
  cost_center = "dops"

  extra_tags = {
    compliance  = "sox"
  }
}
```

## Variables

| Name          | Type | Required | Default | Description                                                                                                                |
|---------------|------|----------|---------|----------------------------------------------------------------------------------------------------------------------------|
| `team`        | string | no*      | null | Team responsible for the project. Must be one of the values defined in `teams.json`                                        |
| `owner`       | string | no*      | null | Email of the project owner                                                                                                 |
| `product`     | string | yes      | - | Product name. Must be one of the values defined in `products.json`                                                         |
| `environment` | string | yes      | - | Environment name. Must be one of the values defined in `environments.json`                                                 |
| `managed_by`  | string | yes      | - | GitHub repository hosting terraform code managing this project                                                             |
| `cost_center` | string | yes      | null | Cost center where the costs for this project should be allocated. Must be one of the values defined in `cost_centers.json` |
| `extra_tags`  | map(string) | no       | {} | Additional custom tags to include                                                                                          |

\* Either `team` or `owner` must be specified

## Valid Values

**Environments:**
- `lab` - Laboratory/experimental environment
- `dev` - Development environment
- `staging` - Staging environment
- `prod` - Production environment

## Outputs

| Name | Description |
|------|-------------|
| `tags` | Map of all tags (standard + extra) |

## Example Output

```hcl
tags = {
  managed_by  = "pexip/infrastructure-repo"
  product     = "shared"
  environment = "prod"
  owner       = "john.doe@pexip.com"
  team        = "vcops"
  cost_center = "dops"
  compliance  = "sox"
}
```

## Module Versioning

When using this module, it's recommended to reference a specific git tag or commit SHA:

```hcl
module "project_tags" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//pexip_project_tags?ref=v1.0.0"
  # ... variables
}
```
