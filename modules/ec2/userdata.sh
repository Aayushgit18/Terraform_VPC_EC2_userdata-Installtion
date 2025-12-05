#!/bin/bash
set -e

echo "### SYSTEM UPDATE ###"
apt update -y
apt upgrade -y
apt install -y curl unzip wget gnupg lsb-release apt-transport-https ca-certificates software-properties-common

# ---------------------------
# Install Docker
# ---------------------------
echo "### INSTALL DOCKER ###"

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
> /etc/apt/sources.list.d/docker.list

apt update -y
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker

# Allow ubuntu user to run Docker
usermod -aG docker ubuntu

# ---------------------------
# Install Java, Maven, Git
# ---------------------------
echo "### INSTALL JAVA, MAVEN, GIT ###"
apt install -y openjdk-17-jdk maven git

# ---------------------------
# Install Jenkins (Ubuntu 22.04 compatible)
# ---------------------------
echo "### INSTALL JENKINS ###"

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io-2023.key | \
  gpg --dearmor | tee /usr/share/keyrings/jenkins.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins.gpg] \
 https://pkg.jenkins.io/debian binary/" \
  > /etc/apt/sources.list.d/jenkins.list

apt update -y
apt install -y fontconfig openjdk-17-jre jenkins || true
systemctl enable jenkins || true
systemctl restart jenkins || true

# ---------------------------
# Install Trivy
# ---------------------------
echo "### INSTALL TRIVY ###"

curl -fsSL https://aquasecurity.github.io/trivy-repo/deb/public.key | \
  gpg --dearmor -o /usr/share/keyrings/trivy.gpg

echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] \
https://aquasecurity.github.io/trivy-repo/deb generic main" \
> /etc/apt/sources.list.d/trivy.list

apt update -y
apt install -y trivy || true

# ---------------------------
# Install SonarScanner
# ---------------------------
echo "### INSTALL SONAR-SCANNER ###"

cd /opt

wget --user-agent="Mozilla/5.0 (X11; Linux x86_64)" \
https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip

unzip sonar-scanner-cli-5.0.1.3006-linux.zip
mv sonar-scanner-5.0.1.3006-linux sonar-scanner

echo 'export PATH=$PATH:/opt/sonar-scanner/bin' >> /etc/profile
ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner || true

# ---------------------------
# Install Artifactory OSS (Docker)
# ---------------------------
echo "### INSTALL ARTIFACTORY OSS (Docker) ###"

mkdir -p /opt/artifactory/data
chown -R 1030:1030 /opt/artifactory
chmod -R 775 /opt/artifactory

docker run -d \
  --name artifactory \
  -p 8081:8081 -p 8082:8082 \
  -v /opt/artifactory/data:/var/opt/jfrog/artifactory \
  releases-docker.jfrog.io/jfrog/artifactory-oss:7.49.8

# ---------------------------
# FINAL VERSION CHECK
# ---------------------------
echo "### VERIFYING INSTALLATIONS ###" | tee /var/log/install-check.log

{
echo "=== TOOL VERSIONS ==="
docker --version
jenkins --version || systemctl status jenkins --no-pager
mvn -version
git --version
java -version
sonar-scanner --version
trivy --version
echo "=== RUNNING CONTAINERS ==="
docker ps
} >> /var/log/install-check.log 2>&1


echo "### USERDATA COMPLETED SUCCESSFULLY ###"
