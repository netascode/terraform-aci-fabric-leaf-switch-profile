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
