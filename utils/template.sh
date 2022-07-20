#https://www.redhat.com/sysadmin/arguments-options-bash-scripts
#!/bin/bash
#To create the templates
template () {
ansible-playbook -i ~/disconnectedinfra/inventory.yml template.yml
}
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

# Get the options
while getopts ":adpt:" option; do
   case $option in
      #Run all through apply
      a) template
         init
	 plan
	 apply;;
      #Delete templated files and Terraform cruft
      d) delete;;
      #Run all through plan
      p) template
         init
         plan;;
      #Only template
      t) template;;
   esac
done

