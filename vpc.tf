provider "aws" {
  region     = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

resource "aws_vpc" "space_beacon" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "space_beacon"
  }
}

resource "aws_internet_gateway" "space_beacon" {
  vpc_id = aws_vpc.space_beacon.id

  tags = {
    Name = "space_beacon"
  }
}

resource "aws_route_table" "space_beacon" {
  vpc_id = aws_vpc.space_beacon.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.space_beacon.id
  }

  tags = {
    Name = "space_beacon"
  }
}

resource "aws_main_route_table_association" "space_beacon" {
  vpc_id         = aws_vpc.space_beacon.id
  route_table_id = aws_route_table.space_beacon.id
}

resource "aws_subnet" "space_beacon_1" {
  vpc_id            = aws_vpc.space_beacon.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "space_beacon_1"
  }
}

resource "aws_subnet" "space_beacon_2" {
  vpc_id            = aws_vpc.space_beacon.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-central-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "space_beacon_2"
  }
}

resource "aws_security_group" "space_beacon" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.space_beacon.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.space_beacon.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "space_beacon"
  }
}