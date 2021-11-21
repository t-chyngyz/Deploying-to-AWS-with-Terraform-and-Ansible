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
