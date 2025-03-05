terraform {
  required_providers {
    cml2 = {
      source = "registry.terraform.io/ciscodevnet/cml2"
      # Docs:
      # https://registry.terraform.io/providers/ciscodevnet/cml2/latest/docs
    }
  }
}

resource "cml2_lab" "tftest" {
  # Create a lab with the following title.
  title = "TF-CML All IOS-XE"
}

data "cml2_images" "images" {
  # This uses CML's image library as a data source.
  # No node definition is required for this data source as all images are
  # desired for further filtering.
}

resource "cml2_node" "router" {
  # for_each docs: https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  # This is where we create each of the routers.
  for_each        = local.filteredimagemap
  lab_id          = cml2_lab.tftest.id
  label           = each.value.name
  nodedefinition  = each.value.nodedef
  x               = each.value.x
  y               = each.value.y
  imagedefinition = each.value.ios_version
  configuration = templatefile("router-base.conf",
    {
      name       = each.value.name,
      nodenumber = each.value.num
    }
  )
}

resource "cml2_node" "CMLMgmt_ExternalConnector" {
  # Create a connector to connect to the CMLMgmt_Switch to the outside world.
  lab_id         = cml2_lab.tftest.id
  label          = "CML Mgmt External Connector"
  nodedefinition = "external_connector"
  x              = local.router_spacing * (length(local.filteredimagemap) - 1) / 2
  y              = -200
  configuration  = "vlan300"
}

resource "cml2_node" "CMLMgmt_Switch" {
  # Create a switch to connect to all of the nodes.
  lab_id         = cml2_lab.tftest.id
  label          = "CML Mgmt Switch"
  nodedefinition = "unmanaged_switch"
  x              = local.router_spacing * (length(local.filteredimagemap) - 1) / 2
  y              = -120
}

resource "cml2_link" "CMLMgmt_Switch_to_CMLMgmt_ExternalConnector" {
  # Create a link from the CMLMgmt_ExternalConnector to the CMLMgmt_Switch
  lab_id = cml2_lab.tftest.id
  node_a = cml2_node.CMLMgmt_ExternalConnector.id
  node_b = cml2_node.CMLMgmt_Switch.id
}

resource "cml2_link" "CMLMgmt_Switch_to_router" {
  # Create a link from each router to the CMLMgmt_Switch
  for_each = cml2_node.router
  lab_id   = cml2_lab.tftest.id
  node_a   = cml2_node.CMLMgmt_Switch.id
  node_b   = each.value.id
}

resource "cml2_lifecycle" "top" {
  lab_id = cml2_lab.tftest.id
  # change dependency based on recommendation from https://github.com/rschmied:
  depends_on = [cml2_link.CMLMgmt_Switch_to_router]
  # This will ensure that the links are created before the lifecycle is
  # triggered.
}
