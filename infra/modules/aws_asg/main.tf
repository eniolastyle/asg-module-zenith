variable "name_prefix" {}

variable "public_subnets" {}

variable "max_size" {}

variable "min_size" {}

variable "desired_capacity" {}

variable "tg_arn" {}

variable "lt_id" {}



resource "aws_autoscaling_group" "terraform-one-asg" {
  name                      = "${var.name_prefix}-asg"
  vpc_zone_identifier       = ["${split(",", var.public_subnets)}"]
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = ["${split(",", var.tg_arn)}"]

  launch_template {
    id      = var.lt_id
    version = "$Latest"
  }
}

