output "tags" {
  value = merge(var.extra_tags, {managed_by: var.managed_by}, {product: var.product}, {environment: var.environment}, {owner: var.owner}, {team: var.team}, {cost_center: var.cost_center})
}