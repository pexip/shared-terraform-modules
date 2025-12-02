output "tags" {
  value = join(var.extra_tags, {managed_by: var.managed_by}, {product: var.product}, {environment: var.environment}, {owner: var.owner}, {team: var.team})
}