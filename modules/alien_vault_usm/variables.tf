variable "name" {}
variable "aws_key_name" {}
variable "aws_region" {}
variable "aws_az" {}
variable "aws_vpc_id" {}
variable "vpc_cidr_block" {}
variable "aws_subnet_id" {}
variable "aws_private_ip" {}
variable "aws_instance_type" {
  default = "t2.large"
}
variable "aws_instance_root_block_device_type" {
  default = "gp2"
}
variable "aws_instance_root_block_device_size" {
  default = 8
}
variable "aws_instance_ebs_block_device_type" {
  default = "gp2"
}
variable "aws_instance_ebs_block_device_size" {
  default = 8
}
