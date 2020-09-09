variable "datacenter" {
  type    = string
  default = "Datacenter"
}

variable "datastore" {
  type    = string
  default = "Datastore01" 
}

variable "resource_pool" {
  type    = string
  default = "HOST01/Resources"
}

variable "host" {
  type    = string
  default = "HOST01"
}

variable "template" {
  type    = string
  default = "TEMPLATES/RHEL8_CINIT"
}

variable "virtual_switch" {
  type    = string
  default = "INFRABUILD.XYZ"
}

variable "port_group" {
  type    = string
  default = "ARTIFACT_COLLECTION"
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
  default = "INFRABUILD.XYZ"
}
