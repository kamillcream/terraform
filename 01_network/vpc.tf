resource "aws_vpc" "main" {
  # 변수(var.vpc_cidr)를 사용하거나 아래처럼 직접 CIDR 블록을 지정할 수 있습니다.
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    # 기존 변수(var.env) 대신 직관적인 이름을 직접 부여했습니다.
    Name = "my-own-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-own-vpc-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "private-subnet-nat-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "my-own-vpc-nat"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "private-route-table"
  }
}

