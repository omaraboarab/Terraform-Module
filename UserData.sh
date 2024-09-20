#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo chown $USER /var/run/docker.sock
sudo chmod 666 /var/run/docker.sock
sudo usermod -aG docker ec2-user
sleep 30
docker run -p 8080:80 -d nginx
