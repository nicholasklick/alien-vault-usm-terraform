resource "aws_security_group" "usm_base_sg" {
  name        = "USMBaseSG"
  description = "For VMs that forward to USM Sensor."
  vpc_id      = "${var.aws_vpc_id}"

  # Outbound anywhere
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.usm_services_sg.id}"]
  }

  tags {
    Name = "USMBaseSG"
  }

}

resource "aws_security_group" "usm_connections_sg" {
  name        = "USMConnectionsSG"
  description = "For remote configuration of USM Sensor."
  vpc_id      = "${var.aws_vpc_id}"

  # Inbound HTTP
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["54.164.225.206/32"]  # Current Alien Vault IP
  }

  # Inbound SSH
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["54.164.225.206/32"] # Current Alien Vault IP
  }

  # Inbound HTTPS
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["54.164.225.206/32"] # Current Alien Vault IP
  }

  # Outbound anywhere
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "USMConnectionsSG"
  }

}

resource "aws_security_group" "usm_services_sg" {
  name        = "USMServicesSG"
  description = "For forwarding from VMs in USMBaseSG."
  vpc_id      = "${var.aws_vpc_id}"

  # Inbound UDP to 514
  ingress {
    from_port       = 514
    to_port         = 514
    protocol        = "udp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  # Inbound UDP to 12291
  ingress {
    from_port       = 12291
    to_port         = 12291
    protocol        = "udp"
    cidr_blocks = ["${var.vpc_cidr_block}"]
  }

  # Outbound anywhere
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "USMServicesSG"
  }

}