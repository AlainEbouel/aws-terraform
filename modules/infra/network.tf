resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name = "demo-route-table"
  }
}

resource "aws_subnet" "public-subnet" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = var.public_subnets[count.index].cidr_block
  availability_zone       = var.public_subnets[count.index].AZ
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnets[count.index].name
  }
}

resource "aws_subnet" "private-subnet" {
  count      = length(var.private_subnets)
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = var.private_subnets[count.index].cidr_block


  tags = {
    Name = var.private_subnets[count.index].name
  }
}

resource "aws_network_acl" "demo-NACL" {
  vpc_id = aws_vpc.demo_vpc.id

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "demo-NACL"
  }
}

resource "aws_network_acl_association" "subnet-NACL-association" {
  count          = length(var.public_subnets)
  network_acl_id = aws_network_acl.demo-NACL.id
  subnet_id      = aws_subnet.public-subnet[count.index].id
}


