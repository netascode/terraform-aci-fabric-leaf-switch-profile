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

  name = "LEAF101"
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
