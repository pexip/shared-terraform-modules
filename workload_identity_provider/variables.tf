variable "project_id" {
  type        = string
  description = "GCP project id"
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be 6-30 characters, start with a letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "github_repository" {
  type        = string
  description = "GitHub repository (<org>/<repo>) for which the WIP should be set up"
  validation {
    condition     = can(regex("^[^/]+/[^/]+$", var.github_repository))
    error_message = "github_repository must be in <org>/<repo> format."
  }
}

variable "service_account_id" {
  type        = string
  description = "service account used by the workload identity provider"
}