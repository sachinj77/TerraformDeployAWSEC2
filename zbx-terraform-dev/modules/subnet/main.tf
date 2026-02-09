resource "aws_subnet" "demo-subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-demo_subnet"
  }
}

resource "aws_internet_gateway" "demo-gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-demo-gw"
  }
}

resource "aws_route_table" "demo-route" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gw.id
  }

  tags = {
    Name = "${var.env_prefix}-rtb"
  }
}

resource "aws_route_table_association" "demo-subnet-rt" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-route.id
}
