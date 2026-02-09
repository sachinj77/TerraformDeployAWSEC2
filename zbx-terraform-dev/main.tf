terraform {
  backend "s3" {
    bucket = "terraformstatedev"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "ap-northeast-2"
  # Credentials should be set via environment variables or AWS credentials file
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.env_prefix}-demo_vpc"
  }
}

module "demo-subnet1" {
  source            = "./modules/subnet"
  vpc_id            = aws_vpc.demo-vpc.id
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone        = var.avail_zone
  env_prefix        = var.env_prefix
}

module "demo-ec2-1" {
  source              = "./modules/ec2"
  vpc_id              = aws_vpc.demo-vpc.id
  private_ip          = var.private_ip
  ami_zabbix          = var.ami_zabbix
  inst_type_zabbix    = var.inst_type_zabbix
  avail_zone          = var.avail_zone
  env_prefix          = var.env_prefix
  subnet_id           = module.demo-subnet1.subnet.id
  public_key_location = var.public_key_location
}
