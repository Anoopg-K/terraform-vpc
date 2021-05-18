resource "aws_vpc" "webapp" {
  cidr_block           = var.vpc.cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc.name
  }
}
