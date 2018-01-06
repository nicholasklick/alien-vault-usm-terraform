variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_name" {}
variable "aws_region" {}
variable "aws_az" {}

provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "YOUR_CIDR_BLOCK/16"
  tags {
    Name = "My VPC"
  }
}

# Create a subnet
resource "aws_subnet" "my_subnet" {
  vpc_id = "${aws_vpc.my_vpc.id}"
  cidr_block = "YOUR_CIDR_BLOCK/24"
  availability_zone = "${var.aws_az}"

  tags {
    Name = "My Subnet"
  }
}

# ....
# Prob need a few more steps here to get things/traffic working on AWS VPC: Internet gateway, route table etc.
# But you get the idea.
# ....

# Instantiate Alien Vault
module "alien_vault_usm" {
  name = "MyName"
  source = "../../../../modules/alien_vault_usm"
  aws_key_name = "${var.aws_key_name}"
  aws_region = "${var.aws_region}"
  aws_az = "${var.aws_az}"
  vpc_cidr_block = "you vpc_cidr_block here"
  aws_vpc_id = "${aws_vpc.my_vpc.id}"
  aws_subnet_id = "${aws_subnet.my_subnet.id}"
  aws_private_ip = "custom private ip of your choice here"
}