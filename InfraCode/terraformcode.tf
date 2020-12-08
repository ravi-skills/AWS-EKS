# Provider Information
provider "aws" {
    region = "us-east-1"
    profile = "raviterraform"
}

# Create VPC
resource "aws_vpc" "ravi_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ravi_vpc"
  }
}

# Create Public Subnet1
resource "aws_subnet" "ravi_pub_subnet1" {
  vpc_id     = aws_vpc.ravi_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ravi_pub_subnet1"
  }
}

# Create Public Subnet2
resource "aws_subnet" "ravi_pub_subnet2" {
  vpc_id     = aws_vpc.ravi_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ravi_pub_subnet2"
  }
}

# Create Public Subnet3
resource "aws_subnet" "ravi_pub_subnet3" {
  vpc_id     = aws_vpc.ravi_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "ravi_pub_subnet3"
  }
}

# Create Private Subnet1
resource "aws_subnet" "ravi_prv_subnet1" {
  vpc_id     = aws_vpc.ravi_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "ravi_prv_subnet1"
  }
}

# Create Private Subnet2
resource "aws_subnet" "ravi_prv_subnet2" {
  vpc_id     = aws_vpc.ravi_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "ravi_prv_subnet2"
  }
}

# Create Private Subnet3
resource "aws_subnet" "ravi_prv_subnet3" {
  vpc_id     = aws_vpc.ravi_vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "ravi_prv_subnet3"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "ravi_igw" {
  vpc_id = aws_vpc.ravi_vpc.id

  tags = {
    Name = "ravi_igw"
  }
}

# Create route table (for public subnets) and attach Internet Gateway
resource "aws_route_table" "ravi_rt_public" {
    vpc_id = aws_vpc.ravi_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ravi_igw.id
    }

    tags = {
        Name = "ravi_rt_public"
    }
}

# Associate Public Subnets to the Route Table (public)
resource "aws_route_table_association" "attach_rt_pub_subnet1" {
    subnet_id = aws_subnet.ravi_pub_subnet1.id
    route_table_id = aws_route_table.ravi_rt_public.id
}
resource "aws_route_table_association" "attach_rt_pub_subnet2" {
    subnet_id = aws_subnet.ravi_pub_subnet2.id
    route_table_id = aws_route_table.ravi_rt_public.id
}
resource "aws_route_table_association" "attach_rt_pub_subnet3" {
    subnet_id = aws_subnet.ravi_pub_subnet3.id
    route_table_id = aws_route_table.ravi_rt_public.id
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "ravi_nat_eip" {
  vpc      = true
}

# Create NAT Gateway and attach it to the Public Subnet1
resource "aws_nat_gateway" "ravi_natgw" {
  allocation_id = aws_eip.ravi_nat_eip.id
  subnet_id     = aws_subnet.ravi_pub_subnet1.id
  depends_on = ["aws_internet_gateway.ravi_igw"]

  tags = {
    Name = "ravi_natgw"
  }
}

# Create a Route table (for private subnets) and attach the NAT gateway 
resource "aws_route_table" "ravi_rt_private" {
    vpc_id = aws_vpc.ravi_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.ravi_natgw.id
    }

    tags = {
        Name = "ravi_rt_private"
    }
}

# Associate Private Subnets to the Route Table (private)
resource "aws_route_table_association" "attach_rt_prv_subnet1" {
    subnet_id = aws_subnet.ravi_prv_subnet1.id
    route_table_id = aws_route_table.ravi_rt_private.id
}
resource "aws_route_table_association" "attach_rt_prv_subnet2" {
    subnet_id = aws_subnet.ravi_prv_subnet2.id
    route_table_id = aws_route_table.ravi_rt_private.id
}
resource "aws_route_table_association" "attach_rt_prv_subnet3" {
    subnet_id = aws_subnet.ravi_prv_subnet3.id
    route_table_id = aws_route_table.ravi_rt_private.id
}