#!/bin/sh

DATE_RUN=$(date +"%Y%m%d-%H%M")
DATE=$(date +"%Y-%m-%d")
DATE_TODAY=$(date +"%d")
MONTH_DIR=$(date +"%Y%m")
/usr/local/bin/speedtest-cli --simple --secure | egrep 'Download|Upload' | tr '\n' ' ' > speedtest.txt
#Download_Speed=$(/usr/local/bin/speedtest-cli --simple --secure | egrep 'Download|Upload' | tr '\n' ' ' | awk -F 'Download: ' '{print $2}' | awk -F ' Upload: ' '{print $1}')
#Upload_Speed=$(/usr/local/bin/speedtest-cli --simple --secure | egrep 'Download|Upload' | tr '\n' ' ' | awk -F 'Download: ' '{print $2}' | awk -F ' Upload: ' '{print $2}')
Download=$(/bin/cat speedtest.txt | awk -F 'Download: ' '{print $2}' | awk -F ' Upload: ' '{print $1}' | awk -F ' Mbit/s' '{print $1}')
Upload=$(/bin/cat speedtest.txt | awk -F 'Download: ' '{print $2}' | awk -F ' Upload: ' '{print $2}' | awk -F ' Mbit/s' '{print $1}')

/bin/echo "$DATE_RUN,$Download,$Upload" >> /root/SPEEDTEST_REPORT/$MONTH_DIR/$DATE_TODAY/SSI_SPEEDTEST-REPORT_$DATE.csv
