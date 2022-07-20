resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "Sample-IGW"
  }
}

resource "aws_nat_gateway" "nat" {
  connectivity_type = "private"
  subnet_id = aws_subnet.public[element(keys(aws_subnet.public), 0)].id
  tags = {
    Name        = "Sample-NAT"
  }
}

resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "Public-route"
  }
}

resource "aws_route_table" "private-route" {
  vpc_id       = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    gateway_id     = aws_nat_gateway.nat.id
  }
  tags       = {
    Name     = "Private-Route"
  }
}

resource "aws_route_table_association" "public" {
  for_each  = aws_subnet.public
  subnet_id = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "private" {
  for_each  = aws_subnet.private
  subnet_id = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private-route.id
}
//