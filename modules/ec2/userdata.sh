#!/bin/bash
set -e

# ---------------------------
# System Update
# ---------------------------
apt update -y
apt upgrade -y
apt install -y curl unzip wget gnupg lsb-release apt-transport-https \
ca-certificates software-properties-common

# ---------------------------
# Install Docker
# ---------------------------
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

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
# Install Jenkins (Ubuntu 22.04 + 24.04 supported)
# ---------------------------
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io-2023.key |
    gpg --dearmor | tee /usr/share/keyrings/jenkins.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins.gpg] \
https://pkg.jenkins.io/debian binary/" \
> /etc/apt/sources.list.d/jenkins.list

apt update -y
apt install -y jenkins || true
systemctl enable jenkins || true
systemctl start jenkins || true

# ---------------------------
# Install Trivy
# ---------------------------
curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key |
    gpg --dearmor -o /usr/share/keyrings/trivy.gpg

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb generic main" \
> /etc/apt/sources.list.d/trivy.list

apt update -y
apt install -y trivy || true

# ---------------------------
# Install SonarScanner (working with User-Agent fix)
# ---------------------------
cd /opt

wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" \
https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip

unzip sonar-scanner-cli-*.zip
mv sonar-scanner-5.0.1.3006-linux sonar-scanner
echo 'export PATH=$PATH:/opt/sonar-scanner/bin' >> /etc/profile

# ---------------------------
# Install Artifactory OSS using Docker (ONLY method that works)
# ---------------------------
docker run -d \
  --name artifactory \
  -p 8081:8081 -p 8082:8082 \
  -v /opt/artifactory/data:/var/opt/jfrog/artifactory \
  releases-docker.jfrog.io/jfrog/artifactory-oss:7.49.8

echo "### USERDATA COMPLETED SUCCESSFULLY ###"
