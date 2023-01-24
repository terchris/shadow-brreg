#!/bin/sh

# start cron
/usr/sbin/crond -f -l 8

# to list cron jobs: crontab -l