locals {
  leaf_interface_profiles = [for v in var.interface_profiles : "uni/fabric/leportp-${v}"]
  node_blocks = flatten([
    for selector in var.selectors : [
      for node_block in selector.node_blocks : {
        key = "${selector.name}/${node_block.name}"
        value = {
          selector = selector.name
          name     = node_block.name
          from     = node_block.from
          to       = lookup(node_block, "to", node_block.from)
        }
      }
    ]
  ])
}

resource "aci_rest" "fabricLeafP" {
  dn         = "uni/fabric/leprof-${var.name}"
  class_name = "fabricLeafP"
  content = {
    name = var.name
  }
}

resource "aci_rest" "fabricLeafS" {
  for_each   = { for selector in var.selectors : selector.name => selector }
  dn         = "${aci_rest.fabricLeafP.id}/leaves-${each.value.name}-typ-range"
  class_name = "fabricLeafS"
  content = {
    name = each.value.name
    type = "range"
  }
}

resource "aci_rest" "fabricRsLeNodePGrp" {
  for_each   = { for selector in var.selectors : selector.name => selector if selector.policy != null }
  dn         = "${aci_rest.fabricLeafS[each.value.name].id}/rsleNodePGrp"
  class_name = "fabricRsLeNodePGrp"
  content = {
    tDn = "uni/fabric/funcprof/lenodepgrp-${each.value.policy}"
  }
}

resource "aci_rest" "fabricNodeBlk" {
  for_each   = { for item in local.node_blocks : item.key => item.value }
  dn         = "${aci_rest.fabricLeafS[each.value.selector].id}/nodeblk-${each.value.name}"
  class_name = "fabricNodeBlk"
  content = {
    name  = each.value.name
    from_ = each.value.from
    to_   = each.value.to
  }
}

resource "aci_rest" "fabricRsLePortP" {
  for_each   = toset(local.leaf_interface_profiles)
  dn         = "${aci_rest.fabricLeafP.id}/rslePortP-[${each.value}]"
  class_name = "fabricRsLePortP"
  content = {
    tDn = each.value
  }
}
