#!/bin/bash

#install lxd in vm
sudo apt-get update
sudo snap install lxd

#initialize lxd if no lxdbr0 interface exists
sudo lxd init --auto

# launching Ubuntu 20.04 container named COMP2101-S22
sudo lxc launch ubuntu:20.04 COMP2101-S22

#update /etc/hosts with container's current IP address
sudo lxc list COMP2101-S22 | grep eth0 | awk '{print $3 " COMP2101-S22"}' | sudo tee -a /etc/hosts > /dev/null 
echo "updated current IP address"

# Retrieve default web page from container's web service
if curl -s -o /dev/null http://COMP2101-S22
then
    echo "Web page retrieved successfully."
else
    echo "Failed to retrieve web page."
fi


