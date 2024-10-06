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
  title = "TF-CML All IOS"
}

data "cml2_images" "images" {
  # no node definition is required for this data source as all images are
  # desired for further filtering.
}

resource "cml2_node" "router" {
  for_each        = local.imagemap
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

resource "cml2_node" "prefilteredrouter" {
  for_each        = local.prefilteredimagemap
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

resource "cml2_lifecycle" "top" {
  lab_id = cml2_lab.tftest.id
}
