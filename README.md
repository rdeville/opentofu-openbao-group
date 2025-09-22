<!-- BEGIN DOTGIT-SYNC BLOCK MANAGED -->
<!-- markdownlint-disable -->

# 👋 Welcome to OpenBao Group

<center>

> ⚠️ IMPORTANT !
>
> Main repo is on [framagit.org](https://framagit.org/rdeville-public/opentofu/openbao-group).
>
> On other online git platforms, they are just mirror of the main repo.
>
> Any issues, pull/merge requests, etc., might not be considered on those other
> platforms.

</center>

---

<center>

[![Licenses: (MIT OR BEERWARE)][license_badge]][license_url]
[![Changelog][changelog_badge]][changelog_badge_url]
[![Build][build_badge]][build_badge_url]
[![Release][release_badge]][release_badge_url]

</center>

[build_badge]: https://framagit.org/rdeville-public/opentofu/openbao-group/badges/main/pipeline.svg
[build_badge_url]: https://framagit.org/rdeville-public/opentofu/openbao-group/-/commits/main
[release_badge]: https://framagit.org/rdeville-public/opentofu/openbao-group/-/badges/release.svg
[release_badge_url]: https://framagit.org/rdeville-public/opentofu/openbao-group/-/releases/
[license_badge]: https://img.shields.io/badge/Licenses-MIT%20OR%20BEERWARE-blue
[license_url]: https://framagit.org/rdeville-public/opentofu/openbao-group/blob/main/LICENSE
[changelog_badge]: https://img.shields.io/badge/Changelog-Python%20Semantic%20Release-yellow
[changelog_badge_url]: https://github.com/python-semantic-release/python-semantic-release

Deployment and management of OpenBao Group.

---

<!-- BEGIN DOTGIT-SYNC BLOCK EXCLUDED CUSTOM_README -->

## 🚀 Usage

### ℹ️ Entity, group & policies attachment

Since a single group should be manage by the module, every attached policies,
identity entity or ideneity groups are attache with the `exclusive` parameter
set to true.

If another team deploy the same group with other attachment, this will lead to
infrastructure drift.

This beahaviour is expected as I consider if this happens, it means something
went wrong, either someone gain access to the vault or another team is making
update to the group deployed by this module without using dedicate
implementation.

Policies can be deployed using another module and will not be integrated to this
module to allow creation of mutualised policies.

For instance, you can to this by using my other openbao modules:

- [OpenBao Policies](https://framagit.org/rdeville-public/opentofu/openbao-policies.git)

### ⚠️ Prerequisite

To deploy resources, the identity defined in the provider configuration must
have enough permission.

The policies can be attached individually or to the groups to which below the
identity.

See [OpenBao Documentation - Policy](https://openbao.org/docs/concepts/policies/)
for more information.

### Deploy a group

```hcl
module "group" {
  source = "git::https://framagit.org/rdeville-public/opentofu/openbao-group.git"

  # Required variables
  name  = "Foo"
}
```

### Add metadata to group

```hcl
module "group" {
  source = "git::https://framagit.org/rdeville-public/opentofu/openbao-group.git"

  # Required variables
  name  = "Foo"

  # Example values
  metadata = {
    key = "value"
  }
}
```

### Deploy an group in another namespace

```hcl
module "group" {
  source = "git::https://framagit.org/rdeville-public/opentofu/openbao-group.git"

  # Required variables
  name  = "foo"

  # Example values
  namespace = "bar"
}
```

### Deploy an subgroups and attach them in another group

If you want to avoid data verification, useful for the examples shown below,
you can set `skip_member_group_verification` to `true`.

Otherwise, terraform `data` evaluation being done early, child group should be
deployed first.

```hcl
module "first_subgroup" {
  source = "git::https://framagit.org/rdeville-public/opentofu/openbao-group.git"

  # Required variables
  name  = "foo"
}

module "second_subgroup" {
  source = "git::https://framagit.org/rdeville-public/opentofu/openbao-group.git"

  # Required variables
  name  = "bar"
}

module "group" {
  source = "git::https://framagit.org/rdeville-public/opentofu/openbao-group.git"

  # Required variables
  name  = "baz"

  # Example variables
  # Using IDs
  member_group_ids = [
    module.first_subgroup.group.id,
  ]
  # Using Names
  member_group_names = [
    module.first_subgroup.group.name,
  ]
  skip_member_group_verification = true
}
```

### Deploy entities and attach them in another group

If you want to avoid data verification, useful for the examples shown below,
you can set `skip_member_entity_verification` to `true`.

Otherwise, terraform `data` evaluation being done early, entities should be
deployed first.

```hcl
resource "vault_identity_entity" "first" {
  name      = "first"
}

resource "vault_identity_entity" "second" {
  name      = "second"
}

module "group" {
  source = "git::https://framagit.org/rdeville-public/opentofu/openbao-group.git"

  # Required variables
  name  = "bar"

  # Example variables
  # Using IDs
  member_entity_ids = [
    resource.vault_identity_entity.first.id
  ]
  # Using Names
  member_entity_names = [
    resource.vault_identity_entity.second.name
  ]
  skip_member_entity_verification = true
}
```


### Deploy policies and attach them in another group

```hcl
data "vault_policy_document" "read_only" {
  rule {
    path         = "secret/*"
    capabilities = ["read"]
    description  = "Allow to read all secrets"
  }
}

data "vault_policy_document" "read_write" {
  rule {
    path         = "secret/*"
    capabilities = ["write"]
    description  = "Allow to read and write all secrets"
  }
}

resource "vault_policy" "read_only" {
  name = "read-only"
  policy = data.vault_policy_document.read-only.hcl
}

resource "vault_policy" "read_write" {
  name = "read-write"
  policy = data.vault_policy_document.read_write.hcl
}

module "group" {
  source = "git::https://framagit.org/rdeville-public/opentofu/openbao-group.git"

  # Required variables
  name  = "bar"

  # Example variables
  # Using entity IDs
  policies = [
    # By IDs
    module.read_only.id,
    # By names
    module.read_write.name,
  ]
}
```

<!-- BEGIN TF-DOCS -->
## ⚙️ Module Content

<details><summary>Click to reveal</summary>

### Table of Content

* [Requirements](#requirements)
* [Resources](#resources)
* [Inputs](#inputs)
  * [Required Inputs](#required-inputs)
  * [Optional Inputs](#optional-inputs)
* [Outputs](#outputs)

### Requirements

* [opentofu](https://opentofu.org/docs/):
  `>= 1.8, < 2.0`
* [vault](https://search.opentofu.org/provider/hashicorp/vault/):
  `~>5.0`

### Data Sources

* [data.vault_identity_entity.ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/identity_entity)
  > Ensure vault identity entities exists, gathered by IDs
* [data.vault_identity_entity.names](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/identity_entity)
  > Ensure vault identity entities exists, gathered by Names
* [data.vault_identity_group.ids](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/identity_group)
  > Ensure vault identity groups exists, gathered by IDs
* [data.vault_identity_group.names](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/identity_group)
  > Ensure vault identity groups exists, gathered by Names
* [data.vault_namespace.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/namespace)
  > Ensure namespace exists

### Resources

* [resource.vault_identity_group.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group)
  > Manage group identity
* [resource.vault_identity_group_member_entity_ids.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids)
  > Manage identity associated with the group
* [resource.vault_identity_group_member_group_ids.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_group_ids)
  > Manage subgroups associated with the group
* [resource.vault_identity_group_policies.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_policies)
  > Manage policies attached to the group

<!-- markdownlint-capture -->
### Inputs

<!-- markdownlint-disable -->
#### Required Inputs

* [name](#name)

##### `name`

String to set the name of the group
<div style="display:inline-block;width:100%;">
<div style="float:left;border-color:#FFFFFF;width:75%;">
<details><summary>Type</summary>

```hcl
string
```

</details>
</div>
</div>

#### Optional Inputs

* [namespace_path](#namespace_path)
* [type](#type)
* [metadata](#metadata)
* [skip_member_group_verification](#skip_member_group_verification)
* [member_group_ids](#member_group_ids)
* [member_group_names](#member_group_names)
* [skip_member_entity_verification](#skip_member_entity_verification)
* [member_entity_ids](#member_entity_ids)
* [member_entity_names](#member_entity_names)
* [policies](#policies)


##### `namespace_path`

Namespace where to deploy the identity if not the namespace set in the
provider.

<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  string
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  null
  ```

  </div>
</details>

##### `type`

Type of the group, internal or external (Forces new resource).

<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  string
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  internal
  ```

  </div>
</details>

##### `metadata`

A Map of additional metadata to associate with the group.
<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  map(string)
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  {}
  ```

  </div>
</details>

##### `skip_member_group_verification`

Boolean to skip evaluation of the existence of subgroups.
Useful when deploying subgroups with parent groups.

<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  bool
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  false
  ```

  </div>
</details>

##### `member_group_ids`

A list of Group IDs to be assigned as group members. Not allowed on external
groups.

<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  set(string)
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  []
  ```

  </div>
</details>

##### `member_group_names`

A list of Group Name to be assigned as group members. Not allowed on external
groups.

<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  set(string)
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  []
  ```

  </div>
</details>

##### `skip_member_entity_verification`

Boolean to skip evaluation of the existence of subgroups.
Useful when deploying subgroups with parent groups.

<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  bool
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  false
  ```

  </div>
</details>

##### `member_entity_ids`

A list of Entity IDs to be assigned as group members. Not allowed on external
groups.

<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  set(string)
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  []
  ```

  </div>
</details>

##### `member_entity_names`

A list of Entity Name to be assigned as group members. Not allowed on external
groups.

<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  set(string)
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  []
  ```

  </div>
</details>

##### `policies`

List of policies IDs or Names to attach to the group.

<details style="width: 100%;display: inline-block">
  <summary>Type & Default</summary>
  <div style="height: 1em"></div>
  <div style="width:64%; float:left;">
  <p style="border-bottom: 1px solid #333333;">Type</p>

  ```hcl
  list(string)
  ```

  </div>
  <div style="width:34%;float:right;">
  <p style="border-bottom: 1px solid #333333;">Default</p>

  ```hcl
  []
  ```

  </div>
</details>
<!-- markdownlint-restore -->

### Outputs

* `group`:
  The deployed group with its policies, identities and subgroups

</details>

<!-- END TF-DOCS -->
<!-- END DOTGIT-SYNC BLOCK EXCLUDED CUSTOM_README -->

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check [issues page][issues_pages].

You can also take a look at the [CONTRIBUTING.md][contributing].

[issues_pages]: https://framagit.org/rdeville-public/opentofu/openbao-group/-/issues
[contributing]: https://framagit.org/rdeville-public/opentofu/openbao-group/blob/main/CONTRIBUTING.md

## 👤 Maintainers

- 📧 [**Romain Deville** \<code@romaindeville.fr\>](mailto:code@romaindeville.fr)
  - Website: [https://romaindeville.fr](https://romaindeville.fr)
  - Github: [@rdeville](https://github.com/rdeville)
  - Gitlab: [@r.deville](https://gitlab.com/r.deville)
  - Framagit: [@rdeville](https://framagit.org/rdeville)

## 📝 License

Copyright © 2025

- [Romain Deville \<code@romaindeville.fr\>](code@romaindeville.fr)

This project is under following licenses (**OR**) :

- [MIT][main_license]
- [BEERWARE][beerware_license]

[main_license]: https://framagit.org/rdeville-public/opentofu/openbao-group/blob/main/LICENSE
[beerware_license]: https://framagit.org/rdeville-public/opentofu/openbao-group/blob/main/LICENSE.BEERWARE

<!-- END DOTGIT-SYNC BLOCK MANAGED -->
