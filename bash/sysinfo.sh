#!/bin/bash

#Get hostname and fully qualified domain name
hostname=$(hostname)
fqdn=$(hostname -f)

#Get operating system name and version
os=$(lsb_release -d | awk -F"\t" '{print $2}')

#Get default IP address 
ip_address=$(ip route get 8.8.8.8 | grep -oP 'src \K\S+')

#Get free disk space on root filesystem
disk_space=$(df -h | grep "/s")

#Output Report
cat <<EOF

Report for $hostname

================================================

Fully Qualified Domain Name:$fqdn
Operating System:$os
IP Address:$ip_address
Free Disk Space on Root Filesystem:$disk_space

====================================================

EOF
