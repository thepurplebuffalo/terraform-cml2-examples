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
