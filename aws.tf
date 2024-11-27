resource "aws_vpc" "project_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Sample-Project"
  }
}

resource "aws_internet_gateway" "project_internet_gateway" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "Sample-IGW"
  }
}

resource "aws_subnet" "project_subnet" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Sample-Subnet"
  }
}

resource "aws_security_group" "project_security_group" {
  name        = "Sample-SG"
  description = "This is a sample security group for demo"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "project_key_pair" {
  key_name   = "Sample_key"
  public_key = file("C:/Users/akush/.ssh/awsdevlnxkey.pub")
}

resource "aws_instance" "project_instance" {
  ami           = "ami-0614680123427b75e"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.project_subnet.id

  vpc_security_group_ids = [aws_security_group.project_security_group.id]

  key_name = aws_key_pair.project_key_pair.key_name

  tags = {
    Name = "Sample-Instance"
  }
}
