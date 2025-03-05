locals {
  # create a list of the node definitions we are interested in:
  desirednodedefinitionlist = ["cat8000v", "csr1000v", "iosv"]

  # create a list of all of the image definitions:
  imagelist = data.cml2_images.images.image_list

  # create a map of the images that match the desired node definitions:
  imagemap = { for i, img in local.imagelist : img.id => {
    name        = "r${i + 1}"
    ios_version = img.id
    nodedef     = img.nodedefinition
    }
    if contains(local.desirednodedefinitionlist, img.nodedefinition)
  }

  # create a list of the images that match the desired node definitions:
  filteredimagelist = [for img in local.imagelist : img
    if contains(local.desirednodedefinitionlist, img.nodedefinition)
  ]

  # create a map of images based on the pre-filtered image list:
  prefilteredimagemap = { for i, img in local.filteredimagelist : img.id => {
    name        = "r${i + 1}"
    ios_version = img.id
    nodedef     = img.nodedefinition
    }
  }
}