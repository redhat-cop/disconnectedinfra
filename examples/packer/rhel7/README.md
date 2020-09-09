# RHEL7 - Vanilla Installationn

This installs a RHEL-7.8 base image with LVM.  Packer is being used standalone here, but lacks a couple of very helpful features.  There is no file templating (i.e. deploying a file with variables such as a Kickstart with a variabilized password) or logic (conditionals/looping).  HCL2 will help address some of these shortcomings, but for the time being is still a beta feature.

A couple of important notes:

1. Make sure you change the root password in the kickstart file to match the RHEL password.  During initial provisioning, the system will connect over SSH via the root account.  The passwords have to match else it won't be able to log in.
2. It's easiest to use a variable file to override the connection configuration for your environment.  You can also just change the variables to make sense.
