# This file contains information about networking: VPC, Subnets, EKS, IGW, NAT GW and RTB #


# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.environment_tag}-vpc"
  }
}


# Subnets
resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.environment_tag}-Private subnet-${(count.index + 1)}"

  }
}

resource "aws_subnet" "public" {
  count             = 3
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${var.environment_tag}-Public subnet-${(count.index + 1)}"
  }
}


# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.environment_tag}-Internet-gateway"
  }
}


# NAT gateway
resource "aws_eip" "nat_gateway" {
  vpc   = true
  count = 3
  tags = {
    Name = "${var.environment_tag}-Internet-gateway-${(count.index + 1)}"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = 3
  allocation_id = aws_eip.nat_gateway.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]
  tags = {
    Name = "${var.environment_tag}-NAT-gateway-${(count.index + 1)}"
  }
}


# Routing tables and associations
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "${var.environment_tag}-public-rtb"
    Description = "Allows outbound traffic for the internet"
  }
}

resource "aws_route_table" "private-rtb" {
  count  = 3
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.*.id[count.index]
  }
  tags = {
    Name        = "${var.environment_tag}-private-rtb-${(count.index + 1)}"
    Description = "NAT gateway for all private subnets"
  }
}

resource "aws_route_table_association" "public-rtb" {
  count          = 3
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "private-rtb" {
  count          = 3
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private-rtb.*.id[count.index]
}