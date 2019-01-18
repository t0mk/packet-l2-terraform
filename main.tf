variable "bgp_password" {
    type = "string"
    default = "955dB0b81Ef"

}

resource "packet_project" "test" {
    name = "testpro"
    bgp_config {
        deployment_type = "local"
        md5 = "${var.bgp_password}"
        asn = 65000
    }
}

resource "packet_reserved_ip_block" "addr" {
    project_id = "${packet_project.test.id}"
    facility = "ewr1"
    quantity = 1
}

resource "packet_device" "test" {
    hostname         = "terraform-test-bgp-sesh"
    plan             = "baremetal_0"
    facility         = "ewr1"
    operating_system = "ubuntu_16_04"
    billing_cycle    = "hourly"
    project_id       = "${packet_project.test.id}"
}

resource "packet_bgp_session" "test" {
	device_id = "${packet_device.test.id}"
	address_family = "ipv4"
}



data "template_file" "bird_conf_template" {
    template = <<EOF
filter packetdns {
    if net = $${floating_ip}/32 then accept;
}
router id $${private_ipv4};
protocol direct {
    interface "lo";
}
protocol kernel {
    scan time 20;
    learn;
    persist;
}
protocol device {
    scan time 10;
}
protocol bgp {
    export filter packetdns;
    local as 65000;
    neighbor $${gateway_ip} as 65530;
    password "$${bgp_password}"; 
}
EOF
    vars = {
        floating_ip  = "${packet_reserved_ip_block.addr.address}"
        private_ipv4 = "${packet_device.test.network.0.address}"
        gateway_ip   = "${packet_device.test.network.0.gateway}"
        bgp_password = "${var.bgp_password}"
    }
}

resource "null_resource" "configure_bird" {

    connection {
        type = "ssh"
        host = "${packet_device.test.access_public_ipv4}"
        private_key = "${file("/home/tomk/keys/tkarasek_key.pem")}"
        agent = false
    }

    provisioner "remote-exec" {
        inline = [
            "apt-get install bird",
            "sysctl net.ipv4.ip_forward=1",
            "mv /etc/bird/bird.conf /etc/bird/bird.conf.original",
        ]
    }
    triggers = {
        template = "${data.template_file.bird_conf_template.rendered}"
    }

    provisioner "file" {
        content     = "${data.template_file.bird_conf_template.rendered}"
        destination = "/etc/bird/bird.conf"
    }
}
