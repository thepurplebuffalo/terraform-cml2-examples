output "test_withcount" {
  # In this output example, the resources are keyed by the 'name' column in
  # the CSV file.  Because lists are ordered, there is an index (i) available
  # that we can use for enumeration (like for assigning the last octet of an
  # IP address).
  value = { for i, csvline in tolist(local.routerinstances) : csvline.name => {
    name        = csvline.name
    ios_version = csvline.ios_version
    x           = csvline.x
    y           = csvline.y
    num         = i + 1
    }
  }
}

output "test_nocount" {
  # This is a basic example of a map without a count that can be used with the
  # for_each meta-argument.  The resources are keyed by the 'name' column in
  # the CSV file.
  value = { for csvline in local.routerinstances : csvline.name => csvline }
}
