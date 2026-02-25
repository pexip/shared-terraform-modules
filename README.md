# Pexip Shared Terraform Modules

This repository contains reusable Terraform modules for Pexip infrastructure.

## Available Modules

### pexip_project_tags

A module for generating standardized tags for Pexip projects in GCP.

See [pexip_project_tags/README.md](pexip_project_tags/README.md) for detailed usage information.

### pam

A module for creating Google Cloud Privileged Access Manager (PAM) entitlements for just-in-time access control.

See [pam/README.md](pam/README.md) for detailed usage information.

### workload_identity_provider

A module for configuring GCP Workload Identity Federation for GitHub Actions, enabling keyless authentication without long-lived service account keys.

See [workload_identity_provider/README.md](workload_identity_provider/README.md) for detailed usage information.

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
