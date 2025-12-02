# Pexip Shared Terraform Modules

This repository contains reusable Terraform modules for Pexip infrastructure.

## Available Modules

### pexip_project_tags

A module for generating standardized tags for Pexip projects in GCP.

See [pexip_project_tags/README.md](pexip_project_tags/README.md) for detailed usage information.

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
