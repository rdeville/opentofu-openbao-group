# Manage group identity
resource "vault_identity_group" "this" {
  namespace = try(data.vault_namespace.this[0].path, null)

  name                       = var.name
  type                       = var.type
  metadata                   = var.metadata
  external_policies          = true
  external_member_entity_ids = true
  external_member_group_ids  = true
}

# Manage subgroups associated with the group
resource "vault_identity_group_member_group_ids" "this" {
  namespace = try(data.vault_namespace.this[0].path, null)

  exclusive = true
  group_id  = vault_identity_group.this.id
  member_group_ids = concat([
    for entity in data.vault_identity_group.ids : entity.id
    ], [
    for entity in data.vault_identity_group.names : entity.id
  ])
}

# Manage identity associated with the group
resource "vault_identity_group_member_entity_ids" "this" {
  namespace = try(data.vault_namespace.this[0].path, null)

  exclusive = true
  group_id  = vault_identity_group.this.id
  member_entity_ids = concat([
    for entity in data.vault_identity_entity.ids : entity.id
    ], [
    for entity in data.vault_identity_entity.names : entity.id
  ])
}

# Manage policies attached to the group
resource "vault_identity_group_policies" "this" {
  namespace = try(data.vault_namespace.this[0].path, null)

  exclusive = true
  group_id  = vault_identity_group.this.id
  policies  = var.policies
}
