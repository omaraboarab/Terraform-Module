#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo yum install -y yum-utils
sudo chmod 666 /var/run/docker.sock
sudo chown $USER /var/run/docker.sock
sudo usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker
sleep 10
docker run -p 8080:80 -d nginx
