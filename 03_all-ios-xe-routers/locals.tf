# This Terraform file contains variable definitions.

locals {
  # create a list of the node definitions we are interested in:
  # desirednodedefinitionlist = ["cat8000v", "csr1000v"]
  desirednodedefinitionlist = ["csr1000v", "cat8000v"]

  # create a list of all of the image definitions:
  imagelist = data.cml2_images.images.image_list

  # create a list of the images that match the desired node definitions:
  filteredimagelist = [for img in data.cml2_images.images.image_list : img
    if contains(local.desirednodedefinitionlist, img.nodedefinition)
  ]

  # 40 pixels per grid square in CML. 40 is a bit tight:
  router_spacing = 60

  # create a map of images based on the pre-filtered image list:
  filteredimagemap = { for i, img in local.filteredimagelist : img.id => {
    name        = "r${i + 1}"
    ios_version = img.id
    nodedef     = img.nodedefinition
    x           = local.router_spacing * i
    y           = 0
    num         = i + 1
    }
  }
}