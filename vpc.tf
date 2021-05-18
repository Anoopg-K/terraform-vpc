# ===============================================================================
# Gathering All Subent Name
# ===============================================================================

data "aws_availability_zones" "available" {
  state = "available"
}


# ===============================================================================
# vpc creation
# ===============================================================================
resource "aws_vpc" "vpc" {
    
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-vpc"
  }
    
}

