provider "aws" {
  profile = var.profile
  region  = var.region-lab
  alias   = "region-lab"
}

#Create VPC in us-east-1
resource "aws_vpc" "vpc_useast" {
  provider             = aws.region-lab
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "lab-vpc"
  }

}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  provider = aws.region-lab
  vpc_id   = aws_vpc.vpc_useast.id
}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region-lab
  state    = "available"
}

#Create subnet # 1 in us-east-1
resource "aws_subnet" "subnet_app" {
  provider          = aws.region-lab
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_useast.id
  cidr_block        = "10.0.1.0/24"
}

#Create subnet #2  in us-east-1
resource "aws_subnet" "subnet_db" {
  provider          = aws.region-lab
  vpc_id            = aws_vpc.vpc_useast.id
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  cidr_block        = "10.0.2.0/24"
}


#Create subnet #3  in us-east-1
resource "aws_subnet" "subnet_bastion" {
  provider          = aws.region-lab
  vpc_id            = aws_vpc.vpc_useast.id
  availability_zone = element(data.aws_availability_zones.azs.names, 2)
  cidr_block        = "10.0.3.0/24"
}


resource "aws_security_group" "lb-sg" {
  provider    = aws.region-lab
  name        = "lb-sg"
  description = "Allow 80 and traffic to Apache SG"
  vpc_id      = aws_vpc.vpc_useast.id

  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.external_ip]
  }
}

#Create SG for allowing TCP/80 from * and TCP/22 from your IP in us-east-1
resource "aws_security_group" "app-sg" {
  provider    = aws.region-lab
  name        = "app-sg"
  description = "Allow TCP/80 & TCP/22"
  vpc_id      = aws_vpc.vpc_useast.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnet_bastion]
  }
  ingress {
    description     = "allow traffic from LB on port 80"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.external_ip]
  }
}


#Create SG for allowing TCP/80 from * and TCP/22 from your IP in us-east-1
resource "aws_security_group" "bastion-sg" {
  provider    = aws.region-lab
  name        = "app-sg"
  description = "Allow TCP/80 & TCP/22"
  vpc_id      = aws_vpc.vpc_useast.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
