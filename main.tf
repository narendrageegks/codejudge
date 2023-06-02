
provider "aws" {
  region = "ap-south-1"
  access_key="*********************"
  secret_key="*************************"
}

# Create VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create public subnet within the VPC
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.example_vpc.id

  dynamic "ingress"{
    for_each=[22,80,443]
    iterator=port
   content{
    from_port   = port.value 
    to_port     = port.value
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  }
    }

resource "aws_instance" "example_instance" {
  ami                    = "ami-0607784b46cbe5816"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  key_name               = "IOT_receiver"

  tags = {
    Name = "example-instance"
  }
}
