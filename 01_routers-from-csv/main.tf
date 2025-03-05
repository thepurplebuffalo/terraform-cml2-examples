# This example was tested with Terraform 1.9.7

terraform {
  required_providers {
    cml2 = {
      source = "registry.terraform.io/ciscodevnet/cml2"
      # Docs:
      # https://registry.terraform.io/providers/ciscodevnet/cml2/latest/docs
    }
  }
}

provider "cml2" {
  # FIXME: Replace with your CML2 server details with real values:
  address     = "https://127.0.0.1"
  username    = "admin"
  password    = "ThisIsNotASecureWayToDoThis"
  skip_verify = true
  # FIXME: everything about this section is insecure.  Don't do this in prod.
  # See https://github.com/CiscoDevNet/terraform-provider-cml2/blob/main/README.md#developing-the-provider
  # for a more secure approach.
}

resource "cml2_lab" "tftest" {
  # Give the CML lab a title:
  title = "Testing Terraform Routers from CSV file"
}

locals {
  # Load the CSV file into a local variable:
  routerinstances = csvdecode(file("router-list.csv"))
}

resource "cml2_node" "router" {
  # for_each docs: https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # See outputs.tf for alternative examples of the 'for' loop.
  for_each = { for i, csvline in tolist(local.routerinstances) : upper(csvline.name) => {
    name        = "MyNamePrefix-${csvline.name}"
    ios_version = csvline.ios_version
    x           = csvline.x
    y           = csvline.y
    num         = i + 1       # 'num' will be used for IP addresses.  The index starts at 0 but IP addresses usually start at 1.
    }
  }
  lab_id          = cml2_lab.tftest.id
  label           = each.value.name
  nodedefinition  = "csr1000v"
  x               = each.value.x
  y               = each.value.y
  imagedefinition = each.value.ios_version
  configuration = templatefile("router-base.conf",
  # Pass a couple variables into the configuration tempplate:
    {
      name       = each.value.name,
      nodenumber = each.value.num
    }
  )
}

resource "cml2_lifecycle" "top" {
  # This section will turn on the lab routers.
  lab_id = cml2_lab.tftest.id
}
