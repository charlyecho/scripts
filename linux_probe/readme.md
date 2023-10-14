Probe.sh
===========

A KISS script to generate a json of a linux based server status

## Installation

1. simply drop the script into the targeted server folder of your choice

2. Make the file executable

> chmod +x probe.sh

## Execution

execute the script to get the json data

> ./probe.sh

or

> sh /path/to/the/script/probe.sh

## Sample response

```text
{
   "name" : "my-server",
   "system" : "Ubuntu 20.04.6 LTS",
   "uptime" : "up 2 weeks, 2 days, 1 hour, 44 minutes",
   "reboot_needed" : "false",
   "root space left" : "2.5T",
   "cpu" : "1.5%",
   "ram" : "3%",
   "swap" : "2%",
   "mysql" : "active",
   "nginx" : "active",
   "php7.4-fpm" : "active",
   "php8.2-fpm" : "active",
   "date" : "2023-10-14T01:49:51-0400"
}
```

## Usage

you can execute it in a cronjob to write a file like so

> sh /path/to/probe.sh > status.json

and you can serve it via a http server or get it via ssh