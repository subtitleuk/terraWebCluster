#Create VPC in us-east-1
resource "aws_vpc" "vpc_master" {
  provider             = aws
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "master_vpc"
  }

}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  provider = aws
  vpc_id   = aws_vpc.vpc_master.id
  tags = {
    Name = "master_igw"
  }



}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws
  state    = "available"
}


#Create subnet # 1 in us-east-1
resource "aws_subnet" "subnet_1" {
  provider          = aws
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "master_subnet_1"
  }

}


#Create subnet #2  in us-east-1
resource "aws_subnet" "subnet_2" {
  provider          = aws
  vpc_id            = aws_vpc.vpc_master.id
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "master_subnet_2"
  }


}

#Create SG for allowing TCP/80 and TCP/443 from * and all ports out
resource "aws_security_group" "webserver-sg" {
  provider    = aws
  name        = "webserver-sg"
  description = "Allow TCP/80 & TCP/443"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 443 from our public IP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description = "allow anyone on port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow anyone on port 22 for ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create SG for LB, only TCP/80,TCP/443 and outbound access
resource "aws_security_group" "lb-sg" {
  provider    = aws
  name        = "lb-sg"
  description = "Allow 443 and traffic to website SG"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

