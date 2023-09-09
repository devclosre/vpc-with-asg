#!/bin/bash
sudo apt update
sudo apt install -y nginx
sudo service nginx start
sudo service nginx enable
sudo service nginx status 
nginx -v