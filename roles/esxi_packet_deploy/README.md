# ESXi on Equinix Metal
This role deploys an ESXi server on an Equinix Metal server.  It is a light Ansible wrapper around a Terraform project that will deploy an ESXi server on Equinix metal and publishes two DNS A records: one for the ESXi server and one for a vSphere server.

## Required Authentication

## Default Variables
```
project_path: "{{ playbook_dir }}"
terraform_state: apply
root_password: BadPassword1234$
```
