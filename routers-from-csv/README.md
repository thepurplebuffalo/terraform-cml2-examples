# Routers from CSV

Have you ever been in a situation where you needed to create a lot of routers
with the same configuration?

Did someone give you a CSV file with the routers' information?

If so, this repository is for you!

## Use of 'FIXME'
There are a few places in the code where I have used 'FIXME' to indicate that
there is something that needs to be fixed.  These are typically either
configuration steps that you will need to adjust for your use case, or else
security concerns that I have not addressed.

The list of 'FIXME's is not exhaustive.

## CSV file
The example CSV has:
* the x,y coordinates of the routers
* the router's name
* the router's IOS version

It's an exercise for the reader to add/remove columns as required for your use
case.

Note: not all version of CML will have all of the IOS versions that are listed.

## Base router configuration
A sample base router config is provided in
[router-base.conf](./router-base.conf).

## Variations

The [outputs.tf](./outputs.tf) file contains a few different examples for the
'''for''' loop that could be used to create the routers.  The 'for' loop
used in the [main.tf](./main.tf) file is a bit more complicated than the others,
but it allows you to create a router with a specific hostname and IP address.

The [main.tf](./main.tf) file also puts the router's name into uppercase.  You
will see this when the Terraform Plan is run.  This helps to show how the
'''for_each''' is actuall processing each element in the map.

## Running
To run this example, you will need to have Terraform installed.  You will also
need to have Cisco Modeling Lab accessible.

The basic steps are:
1. Clone this repository
1. Review/fix all of the 'FIXME's
1. ```terraform init```
1. ```terraform apply -auto-approve``` (does the plan and apply in one step)
1. Wait for the routers to come up
1. Review the routers in CML
1. ```terraform destroy -auto-approve``` (only once you are done)

## Sample output

Have a look at the output from the terraform plan step:


    Terraform will perform the following actions:
    ...
    # cml2_node.router["R1"] will be created
    + resource "cml2_node" "router" {
        + boot_disk_size  = (known after apply)
        + compute_id      = (known after apply)
        + configuration   = <<-EOT
                hostname MyNamePrefix-r1
    ...

1. Notice the ```MyNamePrefix-r1``` in the hostname.
1. Notice the capitalized ```R1``` in the ```cml2_node.router["R1"]```.  This is a result of the ```upper(csvline.name)``` in the for loop.

The output generated from the [outputs.tf](./outputs.tf) file helps to show how the map is created:

    ...
    + test_withcount = {
        + r1 = {
            + ios_version = "csr1000v-161101b"
            + name        = "r1"
            + num         = 1
            + x           = "0"
            + y           = "0"
            }
        + r2 = {
            + ios_version = "csr1000v-170302"
            + name        = "r2"
            + num         = 2
            + x           = "50"
            + y           = "0"
            }
    ...
