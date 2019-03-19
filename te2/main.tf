resource "packet_project" "test" {
    name = "tftest"
}

resource "packet_device" "test" {
  hostname         = "test"
  plan             = "m1.xlarge.x86"
  facility         = "ewr1"
  operating_system = "ubuntu_16_04"
  billing_cycle    = "hourly"
  project_id       = "${packet_project.test.id}"
  network_type     = "layer2-individual"
}

resource "packet_vlan" "test1" {
  description = "VLAN in New Jersey"
  facility    = "ewr1"
  project_id  = "${packet_project.test.id}"
}

resource "packet_vlan" "test2" {
  description = "VLAN in New Jersey"
  facility    = "ewr1"
  project_id  = "${packet_project.test.id}"
}

resource "packet_port_vlan_attachment" "test1" {
  device_id = "${packet_device.test.id}"
  vlan_vnid = "${packet_vlan.test1.vxlan}"
  port_name = "eth1"
  force_bond = false
}

resource "packet_port_vlan_attachment" "test2" {
  device_id = "${packet_device.test.id}"
  vlan_vnid = "${packet_vlan.test2.vxlan}"
  port_name = "eth1"
  force_bond = false
}

