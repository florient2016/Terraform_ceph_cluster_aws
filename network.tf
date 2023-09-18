resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "Aws-Vpc"
  }
}

resource "aws_internet_gateway" "iwg" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "iwg-ceph"
  }
}

resource "aws_subnet" "subnet-ceph" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Subnet-ceph"
  }
}

resource "aws_route_table" "rt-ceph" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.iwg.id
  }
  tags = {
    Name = "Rt-ceph"
  }
}

resource "aws_route_table_association" "Rt-ass" {
  route_table_id = aws_route_table.rt-ceph.id
  subnet_id      = aws_subnet.subnet-ceph.id
}