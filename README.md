<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-fabric-leaf-switch-profile/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-fabric-leaf-switch-profile/actions/workflows/test.yml)

# Terraform ACI Fabric Leaf Switch Profile Module

Manages ACI Fabric Leaf Switch Profile

Location in GUI:
`Fabric` » `Fabric Policies` » `Switches` » `Leaf Switches` » `Profiles`

## Examples

```hcl
module "aci_fabric_leaf_switch_profile" {
  source = "netascode/fabric-leaf-switch-profile/aci"

  name               = "LEAF101"
  interface_profiles = ["PROF1"]
  selectors = [{
    name   = "SEL1"
    policy = "POL1"
    node_blocks = [{
      name = "BLOCK1"
      from = 101
      to   = 101
    }]
  }]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Leaf switch profile name. | `string` | n/a | yes |
| <a name="input_interface_profiles"></a> [interface\_profiles](#input\_interface\_profiles) | List of interface profile names. | `list(string)` | `[]` | no |
| <a name="input_selectors"></a> [selectors](#input\_selectors) | List of selectors. Allowed values `from`: 1-4000. Allowed values `to`: 1-4000. | <pre>list(object({<br>    name   = string<br>    policy = optional(string)<br>    node_blocks = list(object({<br>      name = string<br>      from = number<br>      to   = optional(number)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `fabricLeafP` object. |
| <a name="output_name"></a> [name](#output\_name) | Leaf switch profile name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.fabricLeafP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fabricLeafS](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fabricNodeBlk](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fabricRsLeNodePGrp](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.fabricRsLePortP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->