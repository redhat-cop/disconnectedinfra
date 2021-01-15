variable "datacenter" {
  type    = string
  default = "{{ vsphere.datacenter }}"
}

variable "datastore_cluster" {
  type    = string
  default = "NVMECLUSTER" 
}

variable "cluster" {
  type    = string
  default = "{{ vsphere.cluster }}"
}

variable "template" {
  type    = string
  default = "vyos"
}

variable "virtual_switch" {
  type    = string
  default = "{{ vsphere.switch }}"
}

variable "port_group" {
  type    = string
  default = "{{ vsphere.portgroupname }}"
}

variable "tag_category" {
  type    = string
  default = "INFRABUILD_XYZ"
}

variable "tag" {
  type    = string
  default = "INFRABUILD_XYZ"
}

variable "folder" {
  type    = string
  default = "{{ vsphere.folder }}"
}
