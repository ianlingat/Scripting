#!/bin/bash

rsync_process=$(ps -ef | grep bkpencrypt_rsync.sh | grep -v grep)
#rsync_process=$(ps -ef | grep bkpencrypt_rsync.sh)

DATE=$(date +"%Y%m%d-%H%M%S")
if ! [[ -z $rsync_process ]]; then
        echo "$DATE";
        echo "There is a process running";
else
        echo "$DATE";
        echo "There are no process running";
        echo "Ongoing run of rsync";
        echo "=============================================================";
        rsync -avzuh --progress /var/opt/aldon root@172.1.86.5:/var/opt/
        echo "=============================================================";
        echo "Done running rsync";
fi
