locals {
    fac = "nrt1"
}

resource "packet_project" "test" {
    name = "testpro"
}

resource "packet_device" "test" {
    hostname         = "test"
    plan             = "s1.large.x86"
    facility         = "${local.fac}"
    operating_system = "ubuntu_16_04"
    billing_cycle    = "hourly"
    project_id       = "${packet_project.test.id}"
}

resource "packet_vlan" "test" {
  description = "VLAN1"
  facility    = "${local.fac}"
  project_id  = "${packet_project.test.id}"
}

resource "packet_vlan_attachment" "test" {
  device_id = "${packet_device.test.id}"
  port_name = "eth1"
  vlan_id = "${packet_vlan.test.id}"
}




