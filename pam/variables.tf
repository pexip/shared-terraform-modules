variable "parent_id" {
  description = "The ID of the parent resource (project, folder or organization) where the PAM entitlements will be created."
  type        = string
  validation {
    condition     = can(regex("^(projects|folders|organizations)/.{0,30}$", var.parent_id))
    error_message = "parent_id must be in the format 'projects/{id}', 'folders/{id}', or 'organizations/{id}'."
  }
}

variable "parent_type" {
  description = "The type of the parent resource (Project, Folder or Organization)."
  type        = string
  validation {
    condition     = contains(["Project", "Folder", "Organization"], var.parent_type)
    error_message = "parent_type must be either 'Project', 'Folder' or 'Organization'."
  }
}

variable "require_justification" {
  description = "Whether requester justification is required when requesting the PAM entitlement."
  type        = bool
  default     = false
}

variable "number_of_required_approvers" {
  description = "The number of required approvers for the PAM entitlement."
  type        = number
  default     = 0
}

variable "role" {
  description = "The IAM role to be assigned via PAM."
  type        = string
  validation {
    condition     = can(regex("^roles/[a-zA-Z0-9_.]+$", var.role))
    error_message = "role must be a valid IAM role in the format 'roles/{roleName}'."
  }
}

variable "eligible_users" {
  description = "List of users, groups or service accounts eligible for the PAM entitlement."
  type        = list(string)
  validation {
    condition     = alltrue([for assignee in var.eligible_users : can(regex("^(user:|group:|serviceAccount:).+$", assignee))])
    error_message = "Each assignment group must be in the format 'user:{email}', 'group:{email}', or 'serviceAccount:{email}'."
  }
}

variable "approvers" {
  description = "List of users, groups or service accounts that can approve requests for the PAM entitlement."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for approver in var.approvers : can(regex("^(user:|group:|serviceAccount:).+$", approver))])
    error_message = "Each approver must be in the format 'user:{email}', 'group:{email}', or 'serviceAccount:{email}'."
  }
}

variable "notifiers" {
  description = "List of email recipients to notify when an approval is requested."
  type        = list(string)
  default     = []
}
