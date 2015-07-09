#!/bin/bash
__HOME='/mnt/logs/cloudflare/'
__SCRIPTS="${__HOME}/scripts/"
__SFTP='/usr/bin/sftp'
__SFTP_OPTIONS='-P 2222'
__SRC='metapack.com@share.cloudflare.com@logs2.cloudflare.com'
__DST="${__HOME}/incoming"
__PID="${__HOME}/scripts/incoming.pid"

# Set error handling
set -ev

# Evaulate if PID is already running
PID=$(cat ${__PID}) ||true
if ps -p $PID > /dev/null
then
   echo "Job is already running"
   exit 127
fi

# Create a file with current PID to indicate that process is running.
echo $$ > "${__PID}"

# Ensure PID file is removed on program exit.
trap "rm -f -- '${__PID}'" EXIT

# pull down a list of the files
_FILES=$(${__SFTP} -b ${__SCRIPTS}/batch-ls ${__SFTP_OPTIONS} ${__SRC} | grep -v 'sftp'|grep 'gz')

# Wipe out any previous batch file
rm ${__SCRIPTS}/batch-i

# Build the batch operation list
for i in $_FILES
  do
    echo "get ${i} ${__DST}/${i}" >> ${__SCRIPTS}/batch-i
    echo "rm ${i}" >> ${__SCRIPTS}/batch-i
  done

# Execute the batch operation
${__SFTP} -b ${__SCRIPTS}/batch-i ${__SFTP_OPTIONS} ${__SRC}
