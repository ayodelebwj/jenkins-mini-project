# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}


# Security group to allow SSH and HTTP
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
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
}

data "aws_ami" "my_custom_ami" {

  filter {
    name   = "name"
    values = ["web-ami"]   # match your AMI naming pattern
  }
}

# EC2 instance
resource "aws_instance" "web_instance" {
  ami             = data.aws_ami.my_custom_ami.id
  instance_type   = "t2.micro"              
  key_name        = "terra-kp"              
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "web-Instance"
  }
}
