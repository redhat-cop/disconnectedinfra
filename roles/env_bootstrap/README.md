# Ansible Role: Environment Bootstrap
Uses Ansible to create and run Terraform for environment building.  The role itself is not opionated, but the default variables are.  In other words, you can generate pretty much any JSON you want from a variable, but good starting points are provided as default variables in order to make them easy to use but also easy to override.

Terraform is most commonly written in Hashicorp Configuration Language 2 (HCL2).  Generating valid JSON from provided YAML is generally fairly straightforward.  Generating valid HCL2 from YAML or JSON is a little more complex and error-prone.  Luckily, Terraform also accepts a JSON syntax to run the system.  Ansible generates this JSON syntax directly from YAML rather than using an HCL2 generator or templates in order to make replacing Ansible in the environment generation process simple.  

Similarly, Ansible can call Terraform, but is designed to be easily extracted from that process.  This pattern might become relevant if Terraform were being used on Openshift with a custom built front end.  The front-end might be used to generate JSON which is then passed to a pod that runs Terraform as a job. 

## Requirements
* Terraform binary (will be called via command module)
* If installing from source, Git is required

## Role variables
This role will allow you to specify different Terraform JSON dictionaries in order to flexibly build environments.

The role takes a single variable called `terraform_file`.  `terraform_file` is a list of dictionaries containing the name of a Terraform directory/variable plus a variable called designed to provide custom information for the environment you are running.  This role comes with default variables for deploying some common scenarios where you can plug your own authentication information into.  

For example, you might want to provision an ESXi server with some VM's running on it.  You can provide the login information for vSphere in order to add hosts to it and Cloudflare to update the DNS records for your new server.  You also might not want to write secrets such as the password for vSphere or API Key for cloudflare, so you might specify those values to be provided by environment variables.
```
terraform_file:
- name: 
  content: 
- name:
  content:
```
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
