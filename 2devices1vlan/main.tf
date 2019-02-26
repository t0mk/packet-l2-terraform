locals {
    fac = "nrt1"
}

resource "packet_project" "test" {
    name = "testpro"
}

resource "packet_device" "test1" {
    hostname         = "test1"
    plan             = "s1.large.x86"
    facility         = "${local.fac}"
    operating_system = "ubuntu_16_04"
    billing_cycle    = "hourly"
    project_id       = "${packet_project.test.id}"
}

resource "packet_device" "test2" {
    hostname         = "test2"
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

resource "packet_port_vlan_attachment" "test1" {
  device_id = "${packet_device.test1.id}"
  # 2nd port is eth1
  port_id = "${packet_device.test1.ports.2.id}"
  vlan_id = "${packet_vlan.test.id}"
}

resource "packet_port_vlan_attachment" "test2" {
  device_id = "${packet_device.test2.id}"
  # 2nd port is eth1
  port_id = "${packet_device.test2.ports.2.id}"
  vlan_id = "${packet_vlan.test.id}"
}

resource "packet_port_disbond" "test" {
  device_id = "${packet_device.test2.id}"
  port_id = "${packet_device.test2.ports.1.id}"
}

