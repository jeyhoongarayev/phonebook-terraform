#!/usr/bin/env bash

yum update
yum install docker -y
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker

yum install git -y

cat <<HEREDOC >/root/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
-----END OPENSSH PRIVATE KEY-----
HEREDOC

chmod 0400 /root/.ssh/id_rsa

mkdir -p /src/my-frontend-app

cd /src/my-frontend-app

ssh-keyscan github.com >>/root/.ssh/known_hosts
git clone git@github.com:H-Orkhan/phone-app-frontend.git

cd phone-app-frontend

docker build -t my-frontend-app:v1.0.0 .
docker run -di -e PHONEBOOK_BACKEND_API=${backend_url} --name my-fronted-app -p 80:80 my-frontend-app:v1.0.0
