

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


# ===============================================================================
# Internet Gate Way For Vpc
# ===============================================================================
resource "aws_internet_gateway" "igw" {
    
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project}-igw"
  }
}

# ===============================================================================
# subent public1
# ===============================================================================

resource "aws_subnet" "public1" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 0)
  availability_zone        = element(data.aws_availability_zones.available.names,0)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-public1"
  }
}

# ===============================================================================
# subent public2
# ===============================================================================

resource "aws_subnet" "public2" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 1)
  availability_zone        = element(data.aws_availability_zones.available.names,1)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-public2"
  }
}


# ===============================================================================
# subent public3
# ===============================================================================

resource "aws_subnet" "public3" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 2)
  availability_zone        = element(data.aws_availability_zones.available.names,2)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-public-3"
  }
}


# ===============================================================================
# subent private1
# ===============================================================================

resource "aws_subnet" "private1" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 3)
  availability_zone        = element(data.aws_availability_zones.available.names,0)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-private1"
  }
}

# ===============================================================================
# subent private2
# ===============================================================================

resource "aws_subnet" "private2" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 4)
  availability_zone        = element(data.aws_availability_zones.available.names,1)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-private2"
  }
}


# ===============================================================================
# subent private3
# ===============================================================================

resource "aws_subnet" "private3" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 5)
  availability_zone        = element(data.aws_availability_zones.available.names,2)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-private3"
  }
}
