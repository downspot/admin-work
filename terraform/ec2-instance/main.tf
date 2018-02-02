variable "aws_region" {}
variable "instance_type" {}
variable "key_name" {}
variable "vpc_security_group_ids" {}
variable "subnet_id" {}
variable "iam_instance_profile" {}
variable "tag_env" {}
variable "user_data" {}

provider "aws" {
  region = "${var.aws_region}"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

resource "aws_instance" "example" {
  ami 			 = "${data.aws_ami.amazon_linux.id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.vpc_security_group_ids}"]
  iam_instance_profile   = "${var.iam_instance_profile}"
  user_data              = "${var.user_data}"

  tags {
    Name = "${var.tag_env}"
    ProductCode = "value"
    InventoryCode = "value"
    Environment = "${var.tag_env}"
  }
}


output "image_id" {
    value = "${data.aws_ami.amazon_linux.id}"
}

output "id" {
  value       = ["${aws_instance.kafka.id}"]
}

output "private_ip" {
  value       = ["${aws_instance.kafka.private_ip}"]
}
