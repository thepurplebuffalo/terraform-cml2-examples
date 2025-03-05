#!/usr/bin/env python3.11

# convert a json file to an Ansible inventory file

import json
import sys

# sample json file from Terraform:
# {
#   "router_ip_addresses": {
#     "sensitive": false,
#     "type": [
#       "tuple",
#       [
#         "string",
#         "string"
#       ]
#     ],
#     "value": [
#       "10.10.10.8",
#       "10.10.10.7"
#     ]
#   }
# }


def main():
    # Using the "Click" library to parse command line arguments would have been
    # cleaner, but would have also required an additional library on the
    # system.  By using sys.argv, we can keep the script portable.
    if len(sys.argv) != 3:
        print("Usage: json-to-inventory.py <json file> <inventory file>")
        sys.exit(1)

    json_file = sys.argv[1]
    inventory_file = sys.argv[2]
    with open("ansible/inventory-vars.txt", 'r') as f:
        vars = f.read()
    with open(json_file, 'r') as f:
        data = json.load(f)
        with open(inventory_file, 'w') as f:
            f.write('[routers]\n')
            for host in data["router_ip_addresses"]["value"]:
                f.write(host + '\n')
            f.write('\n')
            f.write(vars)


if __name__ == "__main__":
    main()
