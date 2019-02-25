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

resource "packet_vlan" "test1" {
  description = "VLAN1"
  facility    = "${local.fac}"
  project_id  = "${packet_project.test.id}"
}

resource "packet_vlan" "test2" {
  description = "VLAN2"
  facility    = "${local.fac}"
  project_id  = "${packet_project.test.id}"
}

resource "packet_vlan_attachment" "test1" {
  device_id = "${packet_device.test.id}"
  # 2nd port is eth1
  port_id = "${packet_device.test.ports.2.id}"
  vlan_id = "${packet_vlan.test1.id}"
}

resource "packet_vlan_attachment" "test2" {
  device_id = "${packet_device.test.id}"
  # 2nd port is eth1
  port_id = "${packet_device.test.ports.2.id}"
  vlan_id = "${packet_vlan.test2.id}"
}



