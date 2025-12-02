locals {
  environments = jsondecode(file("${path.module}/environments.json"))
  products     = jsondecode(file("${path.module}/products.json"))
  teams        = jsondecode(file("${path.module}/teams.json"))
}

check "owner_or_team_set" {
  assert {
    condition     = var.team != null || var.owner != null
    error_message = "The 'owner' variable must be set when the 'team' variable is not set."
  }
}

variable "team" {
  type    = string
  default = null
  validation {
    condition     = var.team == null ? true : contains(local.teams, var.team)
    error_message = "Team must be one of the values defined in teams.json."
  }
}

variable "product" {
  type = string
  validation {
    condition     = contains(local.products, var.product)
    error_message = "Product must be one of the values defined in products.json."
  }
}

variable "environment" {
  type = string
  validation {
    condition     = contains(local.environments, var.environment)
    error_message = "Environment must be one of the values defined in environments.json."
  }
}

variable "owner" {
  type    = string
  default = null
}

variable "managed_by" {
  type        = string
  description = "GitHub repository hosting terraform code managing this project"
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
