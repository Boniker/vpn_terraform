#!/bin/bash
sudo apt update -y
sudo apt upgrade -y

sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

sudo systemctl restart nginx