#!/bin/bash

CurrentDate=`date "+%Y_%m_%d"`
FileDate=`/bin/date -d "-15 min" "+%Y_%m_%d-%H_%M"`

[ -d /mnt/logs/cloudflare/$CurrentDate ] || mkdir /mnt/logs/cloudflare/$CurrentDate

/usr/bin/sftp -P 2222 metapack.com@share.cloudflare.com@logs2.cloudflare.com:logs-$FileDate*.gz /mnt/logs/cloudflare/$CurrentDate/

/bin/gunzip /mnt/logs/cloudflare/$CurrentDate/logs-$FileDate*.gz
