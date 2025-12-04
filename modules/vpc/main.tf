data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "${var.tags["Name"]}-vpc" })
}

locals {
  az_list = slice(data.aws_availability_zones.available.names, 0, var.azs)
}

resource "aws_subnet" "public" {
  for_each = { for idx, az in local.az_list : idx => az }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.key + 1)
  map_public_ip_on_launch = true
  availability_zone       = each.value

  tags = merge(var.tags, { Name = "${var.tags["Name"]}-public-${each.key + 1}" })
}

resource "aws_subnet" "private" {
  for_each = { for idx, az in local.az_list : idx => az }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, var.azs + each.key + 1)
  availability_zone = each.value

  tags = merge(var.tags, { Name = "${var.tags["Name"]}-private-${each.key + 1}" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.tags["Name"]}-igw" })
}

resource "aws_eip" "nat" {
  count = var.nat ? 1 : 0
  tags  = merge(var.tags, { Name = "${var.tags["Name"]}-nat-eip" })
}

resource "aws_nat_gateway" "natgw" {
  count         = var.nat ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = element(values(aws_subnet.public), 0).id

  tags = merge(var.tags, { Name = "${var.tags["Name"]}-natgw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, { Name = "${var.tags["Name"]}-public-rt" })
}

resource "aws_route_table_association" "public_assocs" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  dynamic "route" {
    for_each = var.nat ? [1] : []

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.natgw[0].id
    }
  }

  tags = merge(var.tags, { Name = "${var.tags["Name"]}-private-rt" })
}

resource "aws_route_table_association" "private_assocs" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
