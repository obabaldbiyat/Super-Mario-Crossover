#!/bin/bash

#Installing Docker 
sudo apt -y update
sudo apt -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt -y update
sudo apt -y install docker-ce

#Creating container 
sudo docker run -d -p 80:80 obab/nginx-personalised-with-index.html:latest
