# Creating  VPC using Terraform
In this project a VPC with public and private subnets is set up using terraform. Data source feature is used to make all the subnets available. Values are passed to variables using tfvars file.

## Prerequisites for this project
- IAM user with necessary policies attached or AWS CLI access
- Terraform installed on your system

If you do not have Terraform installed on your system [Click here](https://www.terraform.io/downloads.html)

## Declaring variables
```sh
$vim variable.tf

variable "region" {}
variable "access_key" {}
variable "secret_key" {}
variable "vpc_cidr" {}
variable "project" {}
```
## Provider file
```sh
$vim provider.tf

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
```

## Tfvars file
```sh
$vim terraform.tfvars

region = "enter your region"
access_key = "enter your access key"
secret_key = "enter your secret key"
project = "enter your project name"
vpc_cidr = "enter the cidr block"
```

## Main .tf file
```sh
$vim vpc.tf

# ===================================================================
# Gathering All Subent Name
# ===================================================================

data "aws_availability_zones" "available" {
  state = "available"
}


# ===================================================================
# vpc creation
# ===================================================================
resource "aws_vpc" "vpc" {
    
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project}-vpc"
  }
    
}


# ===================================================================
# Internet Gate Way For Vpc
# ===================================================================
resource "aws_internet_gateway" "igw" {
    
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project}-igw"
  }
}

# ===================================================================
# subent public1
# ===================================================================

resource "aws_subnet" "public1" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 0)
  availability_zone        = element(data.aws_availability_zones.available.names,0)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-public1"
  }
}

# ===================================================================
# subent public2
# ===================================================================

resource "aws_subnet" "public2" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 1)
  availability_zone        = element(data.aws_availability_zones.available.names,1)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-public2"
  }
}


# ===================================================================
# subent public3
# ===================================================================

resource "aws_subnet" "public3" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 2)
  availability_zone        = element(data.aws_availability_zones.available.names,2)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-public-3"
  }
}


# ===================================================================
# subent private1
# ===================================================================

resource "aws_subnet" "private1" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 3)
  availability_zone        = element(data.aws_availability_zones.available.names,0)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-private1"
  }
}

# ===================================================================
# subent private2
# ===================================================================

resource "aws_subnet" "private2" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 4)
  availability_zone        = element(data.aws_availability_zones.available.names,1)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-private2"
  }
}


# ===================================================================
# subent private3
# ===================================================================

resource "aws_subnet" "private3" {
    
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = cidrsubnet(var.vpc_cidr, 3, 5)
  availability_zone        = element(data.aws_availability_zones.available.names,2)
  map_public_ip_on_launch  = true
  tags = {
    Name = "${var.project}-private3"
  }
}



# ===================================================================
# Creating Elastic Ip For NAT Gateway.
# ===================================================================

resource "aws_eip" "eip" {
  vpc      = true
  tags     = {
    Name = "${var.project}-eip"
  }
}


# ===================================================================
# Creating NAT Gateway.
# ===================================================================

resource "aws_nat_gateway" "nat" {
    
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "${var.project}-nat"
  }
}

# ===================================================================
# Public Route Table
# ===================================================================

resource "aws_route_table" "public" {
    
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public"
  }
}


# ===================================================================
# Private Route Table
# ===================================================================

resource "aws_route_table" "private" {
    
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project}-private"
  }
}


# ===================================================================
# Public Route Table Association
# ===================================================================

resource "aws_route_table_association" "public1" {        
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {      
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "public3" {       
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public.id
}




# ===================================================================
# Private Route Table Association
# ===================================================================

resource "aws_route_table_association" "private1" {        
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {      
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private3" {       
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private.id
}
```
## Display output
```sh
output "aws_eip" {
value = aws_eip.eip.public_ip
}
output "aws_vpc" {
value = aws_vpc.vpc.id
}
output "aws_internet_gateway" {
value = aws_internet_gateway.igw.id
}
output "aws_nat_gateway" {
value = aws_nat_gateway.nat.id
}
output "aws_route_table_public" {
value = aws_route_table.public.id
}
output "aws_route_table_private" {
value = aws_route_table.private.id
}
```

```sh
$terraform validate
$terraform plan
$terraform apply
```
