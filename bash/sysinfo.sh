#!/bin/bash

#Get Fully-qualified domain name by using hostname command
fqdn=$(hostname -f)
echo "FQDN: $fqdn"

#OS name and version by using hostnamectl command
info=$(hostnamectl)
echo "OS info: $info"

#IP Addresses excluding ones that start with 127
ipadd=$(hostname -I | awk '!/^127/ {print}')
echo "IP addresses: $ipadd"

#Root Filesystem Space availability
rfs=$(df -h)
echo "Root Filesystem Space: $rfs"

exit


