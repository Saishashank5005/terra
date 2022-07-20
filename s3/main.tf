terraform {
  backend "s3" {
    bucket = "shashank-zelar"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region     = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}

//resource "aws_s3_bucket" "onebucket" {
//  bucket = "${var.s3-bucket}"
//  acl = "${var.acl-value}"
//  versioning {
//    enabled = true
//  }
//  tags = {
//    Name = "Bucket1"
//    Environment = "Test"
//  }
//}

resource "aws_vpc" "vpc" {
  cidr_block              = "${var.vpc-cidr}"
  instance_tenancy        = "default"

  tags      = {
    Name    = "Sample-vpc"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "Sample-vpc"
  }
}

resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-1-cidr}"
  availability_zone       = "us-east-1a"

  tags      = {
    Name    = "Public Subnet 1"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.public-subnet-2-cidr}"
  availability_zone       = "us-east-1b"

  tags      = {
    Name    = "Public Subnet 2"
  }
}

resource "aws_subnet" "public-subnet-3" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.public-subnet-3-cidr}"
  availability_zone        = "us-east-1c"

  tags      = {
    Name    = "Public Subnet 3"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags       = {
    Name     = "Public Route Table"
  }
}

resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-1.id
  route_table_id      = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-2.id
  route_table_id      = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-subnet-3-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-3.id
  route_table_id      = aws_route_table.public-route-table.id
}


resource "aws_nat_gateway" "Nat-1" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.public-subnet-1.id
  tags      = {
    Name    = "Nat-1"
  }
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-1-cidr}"
  availability_zone        = "us-east-1a"
  tags      = {
    Name    = "Private Subnet 1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-2-cidr}"
  availability_zone        = "us-east-1b"
  tags      = {
    Name    = "Private Subnet 2"
  }
}

resource "aws_subnet" "private-subnet-3" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-3-cidr}"
  availability_zone        = "us-east-1c"
  tags      = {
    Name    = "Private Subnet 3"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id       = aws_vpc.vpc.id
  route {
    cidr_block = "10.0.4.0/24"
    gateway_id = aws_nat_gateway.Nat-1.id
  }
  tags       = {
    Name     = "Private Route Table"
  }
}

resource "aws_route_table_association" "private-subnet-1-route-table-association"{
  subnet_id = "${aws_subnet.private-subnet-1.id}"
  route_table_id = "${aws_route_table.private-route-table.id}"
}
resource "aws_route_table_association" "private-subnet-2-route-table-association"{
  subnet_id = "${aws_subnet.private-subnet-2.id}"
  route_table_id = "${aws_route_table.private-route-table.id}"
}
resource "aws_route_table_association" "private-subnet-3-route-table-association"{
  subnet_id = "${aws_subnet.private-subnet-3.id}"
  route_table_id = "${aws_route_table.private-route-table.id}"
}