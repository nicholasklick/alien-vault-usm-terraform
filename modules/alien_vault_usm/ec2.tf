variable "amis" {
  type = "map"

  default = {
    us-east-1 = "ami-92335ce8"
    us-east-2 = "ami-4c694129"
    us-west-1 = "ami-ae5652ce"
    us-west-2 = "ami-78b71100"
    eu-west-1 = "ami-3c53d645"
    eu-west-2 = "ami-9ca0bef8"
    eu-central-1 = "ami-3ec14a51"
    ap-southeast-1 = "ami-07fb9a7b"
    ap-northeast-1 = "ami-e6f77580"
    ap-southeast-2 = "ami-9840b7fa"
    ap-northeast-2 = "ami-8557f1eb"
    ap-south-1 = "ami-2da1e942"
    sa-east-1 = "ami-14672178"
    ca-central-1 = "ami-08d16b6c"
  }
}

resource "aws_instance" "sensor" {
  ami                         = "${lookup(var.amis, var.aws_region)}"
  availability_zone           = "${var.aws_az}"
  ebs_optimized               = false
  instance_type               = "${var.aws_instance_type}"
  monitoring                  = false
  key_name                    = "${var.aws_key_name}"
  subnet_id                   = "${var.aws_subnet_id}"
  vpc_security_group_ids      = ["${aws_security_group.usm_connections_sg.id}", "${aws_security_group.usm_services_sg.id}"]
  associate_public_ip_address = true
  private_ip                  = "${var.aws_private_ip}"
  source_dest_check           = true

  root_block_device {
    volume_type           = "${var.aws_instance_root_block_device_type}"
    volume_size           = "${var.aws_instance_root_block_device_size}"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/sdh"
    snapshot_id           = ""
    volume_type           = "${var.aws_instance_ebs_block_device_type}"
    volume_size           = "${var.aws_instance_ebs_block_device_size}"
    delete_on_termination = false
  }

  tags {
    Name = "Alien Vault USM Sensor"
  }

}
