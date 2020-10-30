# Ansible Role: Environment Bootstrap
Uses Ansible to create and run Terraform for environment building.

## Requirements
* Terraform binary (will be called via command module)
* If installing from source, Git is required

## Role variables
This role will allow you to specify different Terraform JSON dictionaries in order to flexibly build environments.

You can include your vsphere information in the role or the inventory
vsphere:
  vcenter_server: vcenter.infrabuild.xyz
  cluster: main
  datacenter: Datacenter
  datastore: Datastore1
  folder: Templates
  network: BUILDNET
  username: administrator@vsphere.infrabuild.xyz
  password: BadPassword1234$
  esxi_hostname: 192.168.5.202

In order to update Red Hat based systems, you will need your Red Hat Subscription Manager login ID and pool id.

rhsm:
  username:     Red Hat Subscription Manager username
  password:     Red Hat Subscriptoin Manager password
  pool_id: Red Hat Subscripton Manager Pool ID 

## Example Inventory
all:
  children:
    build:
      hosts:
        localhost:
      vars:
        config_directory: /build_config
        artifact_directory: /build_artifact
        vsphere:
          vcenter_server: vcenter.infrabuild.xyz
          cluster: main
          datacenter: Datacenter
          datastore: Datastore1
          folder: Templates
          network: BUILDNET
          username: administrator@vsphere.infrabuild.xyz
          password: Badpassword1234$
          esxi_hostname: 192.168.5.202
        env:
          VMWARE_USER: "{{ vsphere.username }}"
          VMWARE_PASSWORD: "{{ vsphere.password }}"
          RHSM_PASSWORD: testpassword
          PACKER_CACHE_DIR: "{{ artifact_directory }}"
        packer_default:
          variables:
            ssh_username: vyos


## Example Playbook
---
- hosts: build

  roles:
  - role: env_bootstrap
