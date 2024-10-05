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

The [output.tf](./output.tf) file contains a few different examples for the
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
1. ```terraform init```
2. ```terraform apply -auto-approve``` (does the plan and apply in one step)
3. ```terraform destroy -auto-approve``` (only once you are done)
