locals {
  environments = jsondecode(file("${path.module}/environments.json"))
  products     = jsondecode(file("${path.module}/products.json"))
  cost_centers = jsondecode(file("${path.module}/cost_centers.json"))
}

check "owner_or_team_set" {
  assert {
    condition     = var.team != null || var.owner != null
    error_message = "The 'owner' variable must be set when the 'team' variable is not set."
  }
}

variable "cost_center" {
  type    = string
  default = null
  validation {
    condition     = var.cost_center == null ? true : contains(local.cost_centers, var.cost_center)
    error_message = "Cost center must be one of the values defined in cost_centers.json."
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

variable "team" {
  type    = string
  default = null
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
