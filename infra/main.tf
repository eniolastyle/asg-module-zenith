data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

module "sg" {
  source      = "./modules/aws_sg"
  name_prefix = var.name_prefix
}

module "lt" {
  source          = "./modules/aws_lt"
  name_prefix     = var.name_prefix
  security_groups = module.sg.security_group_id
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  key_name        = var.key_name
}

module "tg" {
  source      = "./modules/aws_tg"
  name_prefix = var.name_prefix
  vpc_id      = data.aws_vpc.default_vpc.id
}

module "lb" {
  source          = "./modules/aws_lb"
  name_prefix     = var.name_prefix
  security_groups = module.sg.security_group_id
  public_subnets  = data.aws_subnets.subnets.ids
  tg_arn          = module.tg.tg_arn
}

module "asg" {
  source           = "./modules/aws_asg"
  name_prefix      = var.name_prefix
  public_subnets   = data.aws_subnets.subnets.ids
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  tg_arn           = module.tg.tg_arn
  lt_id            = module.lt.launch_template_id
}
