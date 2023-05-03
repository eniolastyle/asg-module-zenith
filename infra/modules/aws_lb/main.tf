variable "name_prefix" {}

variable "security_groups" {}

variable "public_subnets" {}

variable "tg_arn" {}

resource "aws_lb" "eni_lb" {
  name               = "${var.name_prefix}-lb"
  ip_address_type    = "ipv4"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${split(",", var.security_groups)}"]
  subnets            = ["${split(",", var.public_subnets)}"]
}

resource "aws_lb_listener" "eni_listener" {
  load_balancer_arn = aws_lb.eni_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }
}

output "lb_dns" {
  value = aws_lb.eni_lb.dns_name
}

output "lb_arn" {
  value = aws_lb.eni_lb.arn
}
