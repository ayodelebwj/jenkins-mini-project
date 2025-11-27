# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Security group to allow SSH and TCP 
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "JENKINS PORT"
    from_port   = 8080
    to_port     = 8080
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

# EC2 instance
resource "aws_instance" "jenkins_instance" {
  ami             = "ami-XYZ==============ABC"
  instance_type   = "t2.micro"              
  key_name        = "terra-kp"               
  security_groups = [aws_security_group.jenkins_sg.name]
  user_data = file("./jenkins-vm-binaries.sh")

  tags = {
    Name = "jenkins-Instance"
  }
}