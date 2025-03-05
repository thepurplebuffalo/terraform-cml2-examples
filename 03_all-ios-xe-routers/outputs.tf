# Terraform Outputs.

# These outputs are converted to JSON with:
#     terraform output -json > terraform-output.json
# ...located in the .gitlab-ci.yaml file.
# the terraform-output.json is then read by the json-to-inventory.py script.


output "router_ip_addresses" {
  value = [
    for router in local.filteredimagemap :
    "10.10.10.${router.num}"
  ]
}
