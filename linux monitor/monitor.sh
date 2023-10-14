#!/bin/bash
#return json data from current server

#list of systemd you want to monitor
systemd_services='mysql\|fpm\|apache\|pm2\|mariadb\|nginx'

# script
# ===================

echo "{"

# name
echo "   "\"name\" : \"$(hostname)\",

# system
distrib=$(hostnamectl | grep 'Operating System')
echo "   "\"system\" : \""${distrib:18}"\",

# uptime
echo "   "\"uptime\" : \"$(uptime -p)\",

# size left, may not be acurate because of mounting points
echo "   "\"root space left\" : \"$(df -h / | grep / | awk '{print $4}')\",

# Get the current usage of CPU and memory
echo "   "\"cpu\" : \"$(top -bn1 | awk '/Cpu/ {print $2}')%\",

# RAM
echo "   "\"ram\" : \"$(free | grep Mem | awk '{print int($3/$2 * 100)}')%\",

# swap
echo "   "\"swap\" : \"$(free | grep Swap | awk '{print int($3/$2 * 100)}')%\",

# systemd
systemd_list=$(systemctl list-units | awk '{print $1;}' | grep $systemd_services | xargs)
for name in $systemd_list; do echo "   "\"${name/%.service}\" : \"$(systemctl is-active "${name}")\",; done

# current server date
echo "   "\"date\" : \"$(date +"%Y-%m-%dT%H:%M:%S%z")\"

echo "}"
