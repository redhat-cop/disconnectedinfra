data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_distributed_virtual_switch" "switch" {
  name          = var.virtual_switch
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_tag_category" "tag_category" {
  name        = var.tag_category
  description = "Namespace specific tags"
  cardinality = "MULTIPLE"
  
  associable_types = [
    "VirtualMachine"
  ]
}

resource "vsphere_tag" "tag" {
  name         = var.tag
  category_id  = vsphere_tag_category.tag_category.id
}

data "vsphere_network" "network" {
  name          = var.port_group
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vyos" {
  name                    = "vyos_test"
  resource_pool_id        = data.vsphere_resource_pool.pool.id
  datastore_id            = data.vsphere_datastore.datastore.id
  host_system_id          = data.vsphere_host.host.id

  num_cpus                = 2
  memory                  = 4096
  guest_id                = data.vsphere_virtual_machine.template.guest_id

  scsi_type               = data.vsphere_virtual_machine.template.scsi_type
   
  tags                    = [vsphere_tag.tag.id]

  folder                  = var.folder

  wait_for_guest_net_routable = false

  network_interface {
    network_id          = data.vsphere_network.network.id
    adapter_type        = data.vsphere_virtual_machine.template.network_interface_types[0]
    use_static_mac      = true
    mac_address         = "00:50:56:AA:BB:CC"
  }

  disk {
    label                 = "disk0"
    size                  = data.vsphere_virtual_machine.template.disks[0].size
    eagerly_scrub         = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned      = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  clone {
    template_uuid         = data.vsphere_virtual_machine.template.id
  }

  extra_config = {
    "guestinfo.metadata"          = filebase64("${path.module}/metadata.tpl")
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = filebase64("${path.module}/userdata.tpl")
    "guestinfo.userdata.encoding" = "base64"
  }
}
