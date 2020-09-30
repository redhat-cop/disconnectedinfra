# Ansible Role: Packer
Uses Ansible to kick off Packer builds with several included reference builds (currently RHEL7 and VYOS).

## Requirements
* Packer binary (will be called via command module)
* date package installed on source system
* If installing from source, Git is required

## Role variables
Action variable will determine whether the systems are created or deployed and tested.  Most often the role will be called twice to build and subsequently test the system.
  action: [ build, test ]

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
          password: DunderMifflin1234$
          esxi_hostname: 192.168.5.202
        env:
          VMWARE_USER: "{{ vsphere.username }}"
          VMWARE_PASSWORD: "{{ vsphere.password }}"
          RHSM_PASSWORD: testpassword
          PACKER_CACHE_DIR: "{{ artifact_directory }}"
        packer_default:
          variables:
            ssh_username: vyos
        override:
          vyos:
            variables:
              ssh_username: vyos
              ssh_password: vyos
              iso_url: http://192.168.173.78/iso/vyos-1.3-rolling-202008250118-amd64.iso
          rhel7:
            variables:
              ssh_username: root
              ssh_password: thisisabadpassword
              iso_url: http://192.168.173.78/iso/rhel-server-7.8-x86_64-dvd.iso
              rhsm_username: redhat_username
              rhsm_pool_id: 8a85f99b6977b7c00169e2352db05b03
        build:
        - build_name: vyos
          should_build: none
          config_generate: true
          run_build: true
          state: poweredon
          packer_file: "{{ vyos | combine(override.vyos,recursive=True) }}"
        - build_name: rhel7
          should_build: build
          config_generate: true
          run_build: true
          state: absent
          packer_file: "{{ rhel7 | combine(override.rhel7,recursive=True) }}"
          files:
          - ks.cfg
          - playbook.yml
        active_config: "{{ build | selectattr('should_build', 'in', '[config,build]') | list }}" 
        active_build: "{{ active_config | selectattr('should_build', 'eq', 'build') | list }}"
        config_files: "{{ active_config | selectattr('files', 'defined') | map(attribute='files') | list | flatten | unique }}"


## Example Playbook
---
- hosts: build

  roles:
  - role: image_creation
    vars:
      action: build 
  - role: image_creation
    vars:
      action: test
