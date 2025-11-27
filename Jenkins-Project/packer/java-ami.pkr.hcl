packer {
  required_version = ">= 1.9.0"

  required_plugins {
    amazon = {
      version = ">= 1.2.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

#============================================
#Provision Java AMI Templates
#============================================

source "amazon-ebs" "java-vm-template-root" {
  region          = "us-east-1"
  instance_type   = "t2.micro"
  ssh_username    = "ubuntu"
  source_ami      = "ami-XYZ==========ABC"
  ami_name        = "java-ami"
  ami_description = "Amazon Linux 2 custom AMI with java and python"
}

build {
  name    = "java-template-build"
  sources = ["source.amazon-ebs.java-vm-template-root"]

  provisioner "file" {
    source      = "java.service"
    destination = "/tmp/java.service"
  }

  provisioner "shell" {
    inline_shebang = "/bin/bash -xe"
    inline = [
      "sudo cp /tmp/java.service /etc/systemd/system/java.service",
      "sudo apt update -y",
      "git clone https://github.com/techbleat/fruits-veg_market.git",
      "cd ~/fruits-veg_market/java",
      "sudo apt install openjdk-17-jdk -y",
      "sudo apt install maven -y",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable java.service",
      "sudo systemctl start java.service",
      "exit 0"
    ]
  }
}