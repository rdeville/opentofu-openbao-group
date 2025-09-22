# Ensure namespace exists
data "vault_namespace" "this" {
  count = var.namespace_path == null ? 0 : 1

  path = var.namespace_path
}

# Ensure vault identity entities exists, gathered by IDs
data "vault_identity_entity" "ids" {
  for_each = var.skip_member_entity_verification ? [] : var.member_entity_ids

  entity_id = each.key
}

# Ensure vault identity entities exists, gathered by Names
data "vault_identity_entity" "names" {
  for_each = var.skip_member_entity_verification ? [] : var.member_entity_names

  entity_name = each.key
}

# Ensure vault identity groups exists, gathered by IDs
data "vault_identity_group" "ids" {
  for_each = var.skip_member_group_verification ? [] : var.member_group_ids

  group_id = each.key
}

# Ensure vault identity groups exists, gathered by Names
data "vault_identity_group" "names" {
  for_each = var.skip_member_group_verification ? [] : var.member_group_names

  group_name = each.key
}
