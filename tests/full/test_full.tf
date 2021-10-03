terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

module "main" {
  source = "../.."

  name               = "LEAF101"
  interface_profiles = ["PROF1"]
  selectors = [{
    name         = "SEL1"
    policy_group = "POL1"
    node_blocks = [{
      name = "BLOCK1"
      from = 101
      to   = 101
    }]
  }]
}

data "aci_rest" "fabricLeafP" {
  dn = "uni/fabric/leprof-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "fabricLeafP" {
  component = "fabricLeafP"

  equal "name" {
    description = "name"
    got         = data.aci_rest.fabricLeafP.content.name
    want        = module.main.name
  }
}

data "aci_rest" "fabricLeafS" {
  dn = "${data.aci_rest.fabricLeafP.id}/leaves-SEL1-typ-range"

  depends_on = [module.main]
}

resource "test_assertions" "fabricLeafS" {
  component = "fabricLeafS"

  equal "name" {
    description = "name"
    got         = data.aci_rest.fabricLeafS.content.name
    want        = "SEL1"
  }
}

data "aci_rest" "fabricRsLeNodePGrp" {
  dn = "${data.aci_rest.fabricLeafS.id}/rsleNodePGrp"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsLeNodePGrp" {
  component = "fabricRsLeNodePGrp"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.fabricRsLeNodePGrp.content.tDn
    want        = "uni/fabric/funcprof/lenodepgrp-POL1"
  }
}

data "aci_rest" "fabricNodeBlk" {
  dn = "${data.aci_rest.fabricLeafS.id}/nodeblk-BLOCK1"

  depends_on = [module.main]
}

resource "test_assertions" "fabricNodeBlk" {
  component = "fabricNodeBlk"

  equal "name" {
    description = "name"
    got         = data.aci_rest.fabricNodeBlk.content.name
    want        = "BLOCK1"
  }

  equal "from_" {
    description = "from_"
    got         = data.aci_rest.fabricNodeBlk.content.from_
    want        = "101"
  }

  equal "to_" {
    description = "to_"
    got         = data.aci_rest.fabricNodeBlk.content.to_
    want        = "101"
  }
}

data "aci_rest" "fabricRsLePortP" {
  dn = "${data.aci_rest.fabricLeafP.id}/rslePortP-[uni/fabric/leportp-PROF1]"

  depends_on = [module.main]
}

resource "test_assertions" "fabricRsLePortP" {
  component = "fabricRsLePortP"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.fabricRsLePortP.content.tDn
    want        = "uni/fabric/leportp-PROF1"
  }
}
