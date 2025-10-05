# Manage group identity
resource "vault_identity_group" "this" {
  namespace = var.namespace_path

  name                       = var.name
  type                       = var.type
  metadata                   = var.metadata
  external_policies          = true
  external_member_entity_ids = true
  external_member_group_ids  = true
}

# Manage subgroups associated with the group
resource "vault_identity_group_member_group_ids" "this" {
  namespace = var.namespace_path

  exclusive        = true
  group_id         = vault_identity_group.this.id
  member_group_ids = tolist(var.member_group_ids)
}

# Manage identity associated with the group
resource "vault_identity_group_member_entity_ids" "this" {
  namespace = var.namespace_path

  exclusive         = true
  group_id          = vault_identity_group.this.id
  member_entity_ids = tolist(var.member_entity_ids)
}

# Manage policies attached to the group
resource "vault_identity_group_policies" "this" {
  namespace = var.namespace_path

  exclusive = true
  group_id  = vault_identity_group.this.id
  policies  = var.policies
}
