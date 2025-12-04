#!/bin/bash
set -e
apt update -y
apt upgrade -y
apt install -y curl unzip gnupg lsb-release apt-transport-https ca-certificates

# Docker install
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Java, Maven, Git
apt install -y openjdk-17-jdk maven git

# Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.asc
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" > /etc/apt/sources.list.d/jenkins.list
apt update -y
apt install -y jenkins
systemctl enable jenkins
systemctl restart jenkins

