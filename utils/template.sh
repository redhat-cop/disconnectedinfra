#https://www.redhat.com/sysadmin/arguments-options-bash-scripts
#!/bin/bash
#To cleanup the generated templates and terraform state
delete () {
ansible-playbook -i ~/disconnectedinfra/inventory.yml template.yml -t never
}
#To initialize terraform
init () {
terraform init -backend-config=backend.conf -input=false
}
#To check config
plan () {
terraform plan -out=tfplan -input=false
}
apply () {
terraform apply -input=false tfplan
}
#To create the templates
template () {
echo "Start test"
ansible-playbook -i ~/disconnectedinfra/inventory.yml /dev/stdin << EOF
---
- hosts: localhost
  connection: local
  gather_facts: false

  vars:
    files: "{{ lookup('ansible.builtin.fileglob', '*.j2', wantlist=True) | map('splitext') | map('first') }}"
    terraform_files:
    - .terraform
    - .terraform.lock.hcl
    - tfplan

  tasks:
  - template:
      src: "{{ item }}.j2"
      dest: "{{ item }}"
    loop: "{{ files }}"

  - file:
      name: "{{ item }}"
      state: absent
    loop: "{{ files + terraform_files }}"
    tags:
    - never
EOF
echo "Ran template"
}

# Get the options
while getopts ":adpt" option; do
   case $option in
      #Run all through apply
      a) template
         init
	 plan
	 apply
	 ;;
      #Delete templated files and Terraform cruft
      d) delete
         ;;
      #Run all through plan
      p) template
         init
         plan
	 ;;
      t) init 
         template
	 ;;
      \?) echo "Invalid option";;
   esac
done

