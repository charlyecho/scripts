#!/bin/bash

#return json probe data from a linux based server

#list of systemd you want to monitor
systemd_services='mysql\|fpm\|apache\|pm2\|mariadb\|nginx\|caddy\|redis-server\|memcached'

# script
# ===================

echo "{"

# name
echo "   "\"name\" : \"$(hostname)\",

# system
echo "   "\"system\" : \"$(hostnamectl | grep 'Operating System' | cut -d ":" -f2 | awk '{$1=$1};1')\",

# Kernel
echo "   "\"kernel\" : \"$(hostnamectl | grep 'Kernel' | cut -d ":" -f2 | awk '{$1=$1};1')\",

# uptime
echo "   "\"uptime\" : \"$(uptime -p)\",

# reboot needed
if test -f "/var/run/reboot-required"; then
    echo "   "\"reboot_needed\" : true,
else
    echo "   "\"reboot_needed\" : false,
fi

# size left, may not be acurate because of mounting points
echo "   "\"root_space_left\" : \"$(df -h / | grep / | awk '{print $4}')\",

# Get the current usage of CPU and memory
echo "   "\"cpu_percent\" : $(top -bn1 | awk '/Cpu/ {print $2}'),

# RAM
echo "   "\"ram_percent\" : $(free | grep Mem | awk '{print ($2 ? int($3/$2 * 100) : -1)}'),

# Swap
echo "   "\"swap_percent\" : $(free | grep Swap | awk '{print ($2 ? int($3/$2 * 100) : -1)}'),

# systemd
systemd_list=$(systemctl list-units | awk '{print $1;}' | grep $systemd_services | xargs)
for service in $systemd_list; do echo "   "\"$service\" : \"$(systemctl is-active "$service")\",; done

# current server date
echo "   "\"date\" : \"$(date +"%Y-%m-%dT%H:%M:%S%z")\"

echo "}"
