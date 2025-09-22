output "group" {
  value = merge([
    vault_identity_group.this,
    {
      member_group_ids    = vault_identity_group_member_group_ids.this
      member_identity_ids = vault_identity_group_member_entity_ids.this
      policies            = vault_identity_group_policies.this
    }
  ]...)
  description = "The deployed group with its policies, identities and subgroups"
}
