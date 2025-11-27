#!/bin/bash

#=========================================================================
# INSTALL GIT
#=========================================================================
sudo apt update && sudo apt upgrade -y
sudo apt install git -y
git --version

#=========================================================================
# INSTALL PACKER AND TERRAFORM
#=========================================================================
# Install prerequisites
sudo apt update && sudo apt install -y gnupg software-properties-common curl

# Add HashiCorp GPG key to keyrings
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Add HashiCorp repo with signed-by reference
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and install Terraform + Packer
sudo apt update -y
sudo apt install -y terraform packer

# Verify
terraform -version
packer -version


#=========================================================================
# INSTALL JENKINS
#=========================================================================
# Install Java
sudo apt install -y openjdk-17-jdk

# Add Jenkins GPG key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
  sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

#=========================================================================
# Add Jenkins repo with signed-by reference
#=========================================================================
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update and install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# Enable and start service
sudo systemctl enable jenkins
sudo systemctl start jenkins