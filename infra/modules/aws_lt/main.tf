variable "name_prefix" {}

variable "security_groups" {}

variable "image_id" {}

variable "instance_type" {}

variable "key_name" {}

data "template_file" "apache_data_script" {
  template = file("./user-data.tpl")
  vars = {
    server = "apache2"
  }
}

resource "aws_launch_template" "apache_lt" {
  name                   = "${var.name_prefix}-lt"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = ["${split(",", var.security_groups)}"]
  user_data              = base64encode(data.template_file.apache_data_script.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}"
    }
  }
}


output "launch_template_id" {
  value = aws_launch_template.apache_lt.id
}
