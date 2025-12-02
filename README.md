# Pexip Shared Terraform Modules

This repository contains reusable Terraform modules for Pexip infrastructure.

## Available Modules

### pexip_project_tags

A module for generating standardized tags for Pexip projects in GCP.

#### Features

- Standardized tagging across all Pexip projects
- Validation of team, product, and environment values
- Support for custom additional tags
- Ensures either owner or team is specified

#### Usage

```hcl
module "project_tags" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//pexip_project_tags"

  team        = "dops"
  product     = "shared"
  environment = "prod"
  managed_by  = "pexip/infrastructure-repo"
  owner       = "john.doe@pexip.com"

  extra_tags = {
    cost_center = "engineering"
    compliance  = "sox"
  }
}
```

#### Variables

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `team` | string | no* | null | Team responsible for the project. Must be one of the values defined in `teams.json` |
| `product` | string | yes | - | Product name. Must be one of the values defined in `products.json` |
| `environment` | string | yes | - | Environment name. Must be one of the values defined in `environments.json` |
| `owner` | string | no* | null | Email of the project owner |
| `managed_by` | string | yes | - | GitHub repository hosting terraform code managing this project |
| `extra_tags` | map(string) | no | {} | Additional custom tags to include |

\* Either `team` or `owner` must be specified

#### Valid Values

**Environments:**
- `lab` - Laboratory/experimental environment
- `dev` - Development environment
- `staging` - Staging environment
- `prod` - Production environment

**Teams:**
- `dops`, `prod`, `head`, `ukir`, `rdge`, `publ`, `enga`, `rdcc`, `rdme`, `sema`, `aunz`, `asia`, `rdsc`, `nord`, `cent`

**Products:**
- `shared`, `midgard`, `cvp`, `vmr`, `google`, `teams`, `vpaas`, `ppi`, `corp`, `beelday`, `kinly-meet`, `vhs`, `infinity`, `erm`, `managed-services`, `courts-core`

#### Outputs

| Name | Description |
|------|-------------|
| `tags` | Map of all tags (standard + extra) |

#### Example Output

```hcl
tags = {
  managed_by  = "pexip/infrastructure-repo"
  product     = "shared"
  environment = "prod"
  owner       = "john.doe@pexip.com"
  team        = "dops"
  cost_center = "engineering"
  compliance  = "sox"
}
```

## Module Versioning

When using these modules, it's recommended to reference a specific git tag or commit SHA:

```hcl
module "project_tags" {
  source = "git::https://github.com/pexip/shared-terraform-modules.git//pexip_project_tags?ref=v1.0.0"
  # ... variables
}
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Test your module changes
4. Submit a pull request
5. Update module documentation in this README

## License

Internal use only - Pexip AS
