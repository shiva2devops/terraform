
# Create a VPC
resource "aws_vpc" "tf_example" {
  cidr_block       = var.cidr
  instance_tenancy = "default"
  tags             = var.tags
}

resource "aws_subnet" "public-sub" {
  vpc_id     = aws_vpc.tf_example.id
  cidr_block = var.public-subnet-cidr

  tags = merge(var.tags, {
    Name = "public-subnet"
  })
}

resource "aws_subnet" "private-sub" {
  vpc_id     = aws_vpc.tf_example.id
  cidr_block = var.private-subnet-cidr

  tags = merge(var.tags, {
    Name = "private-subnet"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.tf_example.id

  tags = merge(var.tags, {
    Name = "igw"
  })
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.tf_example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(var.tags, {
    Name = "public-rt"
  })
}
resource "aws_eip" "auto-eip" {

}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.auto-eip.id
  subnet_id     = aws_subnet.public-sub.id

  tags = merge(var.tags, {
    Name = "Nat-gw"
  })
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.tf_example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.example.id
  }

  tags = merge(var.tags, {
    Name = "private-rt"
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-sub.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private-sub.id
  route_table_id = aws_route_table.private-rt.id
}

