#!/bin/bash
set -e

# ---------------------------
# System Update
# ---------------------------
apt update -y
apt upgrade -y
apt install -y curl unzip wget gnupg lsb-release apt-transport-https ca-certificates software-properties-common

# ---------------------------
# Install Docker
# ---------------------------
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list

apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker

# ---------------------------
# Install Java, Maven, Git
# ---------------------------
apt install -y openjdk-17-jdk maven git

# ---------------------------
# Install Jenkins (Ubuntu 24.04 Fix)
# ---------------------------
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
gpg --dearmor -o /usr/share/keyrings/jenkins-keyring.asc

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" \
> /etc/apt/sources.list.d/jenkins.list

apt update -y
apt install -y jenkins
systemctl enable jenkins
systemctl restart jenkins

# ---------------------------
# Install Trivy
# ---------------------------
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | \
gpg --dearmor -o /usr/share/keyrings/trivy.gpg

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb generic main" \
> /etc/apt/sources.list.d/trivy.list

apt update -y
apt install -y trivy

# ---------------------------
# Install Sonar Scanner
# ---------------------------
cd /opt
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-5.0.1.3006-linux.zip
unzip sonar-scanner-*.zip
mv sonar-scanner-* sonar-scanner

echo 'export PATH=$PATH:/opt/sonar-scanner/bin' >> /etc/profile
source /etc/profile

# ---------------------------
# Install Artifactory OSS
# ---------------------------
wget https://releases.jfrog.io/artifactory/artifactory-debs/pool/jfrog-artifactory-oss.deb
dpkg -i jfrog-artifactory-oss.deb || apt --fix-broken install -y
systemctl enable artifactory
systemctl start artifactory

echo "Userdata execution completed successfully"
