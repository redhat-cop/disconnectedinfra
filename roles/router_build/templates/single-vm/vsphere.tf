data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = var.datastore_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
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

resource "vsphere_folder" "folder" {
  path          = var.folder
  type          = "vm"
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
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vyos" {
  name                    = "VYOS"
  resource_pool_id        = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_cluster_id    = data.vsphere_datastore_cluster.datastore_cluster.id

  num_cpus                = 4
  memory                  = 8096
  guest_id                = data.vsphere_virtual_machine.template.guest_id

  scsi_type               = data.vsphere_virtual_machine.template.scsi_type
   
  tags                    = [vsphere_tag.tag.id]

  folder                  = var.folder

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

  
  provisioner "file" {
    content     = base64decode("{{ lookup('template','./config.boot.j2') | b64encode }}")
    destination = "/config/config.boot"

    connection {
      type =     "ssh"
      user =     "vyos"
      password = "vyos"
      host =     self.default_ip_address
    }
  }
 
  provisioner "file" {
    content     = base64decode("{{ lookup('template','./reload.sh.j2') | b64encode }}")
    destination = "/config/scripts/reload.sh"

    connection {
      type =     "ssh"
      user =     "vyos"
      password = "vyos"
      host =     self.default_ip_address
    }
  }

  provisioner "remote-exec" {
   on_failure = continue
   inline     = [
     "chmod 755 /config/scripts/reload.sh",
     "/usr/bin/sg vyattacfg -c /config/scripts/reload.sh",
     "exit 0"
   ]

    connection {
      type =     "ssh"
      user =     "vyos"
      password = "vyos"
      host =     self.default_ip_address
    }
  }

  extra_config = {
    "guestinfo.metadata"          = filebase64("${path.module}/metadata.tpl")
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = filebase64("${path.module}/userdata.tpl")
    "guestinfo.userdata.encoding" = "base64"
  }
}
