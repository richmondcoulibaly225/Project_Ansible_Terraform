resource "aws_subnet" "Ricky-subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = { Name = "RickyPublic-subnet" }
}

data "aws_internet_gateway" "existing_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "RickyPublicSG" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

  tags = { Name = "RickyPublicSG" }
}

resource "aws_route_table" "Ricky-PublicRT" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.existing_igw.id
  }
}

resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.Ricky-subnet.id
  route_table_id = aws_route_table.Ricky-PublicRT.id
}

resource "aws_instance" "RickyHost1" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.Ricky-subnet.id
  security_groups = [aws_security_group.RickyPublicSG.id]
  key_name = "richmond_key"

  tags = {
    Name = "RickyHost1"
  }  
}

resource "aws_instance" "RickyHost2" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = aws_subnet.Ricky-subnet.id
  security_groups = [aws_security_group.RickyPublicSG.id]
  key_name = "richmond_key"

  tags = {
    Name = "RickyHost2"
  }
}