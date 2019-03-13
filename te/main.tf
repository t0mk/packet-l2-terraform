locals {
    project_id = "52000fb2-ee46-4673-93a8-de2c2bdba33b"
}

resource "packet_vlan" "test" {
  description = "VLAN in New Jersey"
  facility    = "ewr1"
  project_id  = "${local.project_id}"
}

resource "packet_device" "test" {
  hostname         = "test"
  plan             = "m1.xlarge.x86"
  facilities       = ["ewr1"]
  operating_system = "ubuntu_16_04"
  billing_cycle    = "hourly"
  project_id       = "${local.project_id}"
  network_type     = "hybrid"
}

resource "packet_port_vlan_attachment" "test" {
  device_id = "${packet_device.test.id}"
  port_name = "eth1"
  vlan_id = "${packet_vlan.test.id}"
}
