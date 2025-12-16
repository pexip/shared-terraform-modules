resource "google_privileged_access_manager_entitlement" "pam_assignment" {
  location             = "global"
  max_request_duration = "14400s"
  parent               = var.parent_id

  entitlement_id = substr(
  "pam-${replace(lower(split("/", var.role)[1]), ".", "-")}", 0, 63)

  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = var.eligible_users
  }

  privileged_access {
    gcp_iam_access {
      role_bindings {
        role = var.role
      }
      resource      = "//cloudresourcemanager.googleapis.com/${var.parent_id}"
      resource_type = "cloudresourcemanager.googleapis.com/${var.parent_type}"
    }
  }

  dynamic "approval_workflow" {
    for_each = length(var.approvers) > 0 ? [1] : []
    content {
      manual_approvals {
        require_approver_justification = var.require_justification
        steps {
          approvals_needed = var.number_of_required_approvers
          approvers {
            principals = var.approvers
          }
          approver_email_recipients = var.notifiers
        }
      }
    }
  }
}