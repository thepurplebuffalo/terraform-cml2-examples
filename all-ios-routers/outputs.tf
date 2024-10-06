# output a map of the image list filtered by the desired node definitions:
output "IOS_images" {
  value = local.imagemap
}

# output a map of the pre-filtered image list:
output "Prefiltered_IOS_images" {
  value = local.prefilteredimagemap
}
