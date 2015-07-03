#!/bin/bash

CurrentDate=`date "+%Y_%m_%d"`
FileDate=`/bin/date -d "-15 min" "+%Y_%m_%d-%H_%M"`
CurrentTime=`date "+%H%M"`

#Delete all logs older then 60 days old
#Will ensure this runs just onces a day at 02:00
if [ "`date +%H%M`" == "0200" ]
then
	find /mnt/logs/cloudflare -maxdepth 1 -type d -mtime +60 -not -path "/mnt/logs/cloudflare/.ssh" -exec echo rmdir {} \;
fi

[ -d /mnt/logs/cloudflare/$CurrentDate ] || mkdir /mnt/logs/cloudflare/$CurrentDate

/usr/bin/sftp -P 2222 metapack.com@share.cloudflare.com@logs2.cloudflare.com:logs-$FileDate*.gz /mnt/logs/cloudflare/$CurrentDate/

/bin/gunzip /mnt/logs/cloudflare/$CurrentDate/logs-$FileDate*.gz
