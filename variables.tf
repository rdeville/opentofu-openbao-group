# Module Specific variables
# -----------------------------------------------------------------------------
variable "namespace_path" {
  type        = string
  description = <<-EOM
  Namespace where to deploy the identity if not the namespace set in the
  provider.
  EOM

  default  = null
  nullable = true
}

variable "name" {
  type        = string
  description = "String to set the name of the group"
}

variable "type" {
  type        = string
  description = <<-EOM
  Type of the group, internal or external (Forces new resource).
  EOM

  default  = "internal"
  nullable = false
}

variable "metadata" {
  type        = map(string)
  description = "A Map of additional metadata to associate with the group."

  default  = {}
  nullable = false
}

variable "skip_member_group_verification" {
  type        = bool
  description = <<-EOM
  Boolean to skip evaluation of the existence of subgroups.
  Useful when deploying subgroups with parent groups.
  EOM

  default  = false
  nullable = false
}

variable "member_group_ids" {
  type        = set(string)
  description = <<-EOM
  A list of Group IDs to be assigned as group members. Not allowed on external
  groups.
  EOM

  default  = []
  nullable = false
}

variable "skip_member_entity_verification" {
  type        = bool
  description = <<-EOM
  Boolean to skip evaluation of the existence of subgroups.
  Useful when deploying subgroups with parent groups.
  EOM

  default  = false
  nullable = false
}

variable "member_entity_ids" {
  type        = set(string)
  description = <<-EOM
  A list of Entity IDs to be assigned as group members. Not allowed on external
  groups.
  EOM

  default  = []
  nullable = false
}

variable "policies" {
  type        = list(string)
  description = <<-EOM
  List of policies IDs or Names to attach to the group.
  EOM

  default = []
}
