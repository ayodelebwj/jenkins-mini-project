# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Security group to allow SSH and TCP 
resource "aws_security_group" "python_sg" {
  name        = "python-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "PYTHON PORT"
    from_port   = 9000
    to_port     = 9000
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

# Retrieve Python AMI
data "aws_ami" "my_custom_ami" {

  filter {
    name   = "name"
    values = ["python-app-ami"]  
  }
}

# EC2 instance
resource "aws_instance" "python_instance" {
  ami             = data.aws_ami.my_custom_ami.id
  instance_type   = "t2.micro"             
  key_name        = "terra-kp"              
  security_groups = [aws_security_group.python_sg.name]
    
  tags = {
    Name = "python-Instance"
  }
}
