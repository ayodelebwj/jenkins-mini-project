#============================================
#Provision Web, Python and Java AMI Templates
#============================================

data "amazon-parameterstore" "ubuntu_2404" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

source "amazon-ebs" "python-vm-template-root" {
  region          = "us-east-1"
  instance_type   = "t2.micro"
  ssh_username    = "ubuntu"
  source_ami    = data.amazon-parameterstore.ubuntu_2404.value
  ami_name        = "python-app-ami"
  ami_description = "Amazon Linux 2 custom AMI with java and python"
}

build {
  name    = "python-template-build"
  sources = ["source.amazon-ebs.python-vm-template-root"]

  provisioner "file" {
    source      = "python.service"
    destination = "/tmp/python.service"
  }


  provisioner "shell" {
    inline_shebang = "/bin/bash -xe"
    inline = [
      "sudo cp /tmp/python.service /etc/systemd/system/python.service",
      "sudo apt update -y",
      "git clone https://github.com/techbleat/fruits-veg_market.git",
      "sudo apt install python3 python3-pip -y",
      "cd ~/fruits-veg_market/python",
      "sudo apt install python3-venv -y",
      "python3 -m venv .venv",
      "source .venv/bin/activate",
      "python -m pip install -r requirements.txt",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable python.service",
      "sudo systemctl start python.service",
      "exit 0"
    ]
  }
}