#!/bin/bash

DATE_RUN=$(date +"%Y%m%d-%H%M")
DATE=$(date +"%Y-%m-%d")
DATE_YESTERDAY=$(date +"%d" -d "yesterday")
MONTH_DIR=$(date +"%Y%m" -d "yesterday")

mkdir ~/SPEEDTEST_REPORT/$MONTH_DIR
mkdir ~/SPEEDTEST_REPORT/$MONTH_DIR/$DATE_YESTERDAY
scp -p superuser_cdl@10.77.10.1:/root/SPEEDTEST_REPORT/$MONTH_DIR/$DATE_YESTERDAY/* ~/SPEEDTEST_REPORT/$MONTH_DIR/$DATE_YESTERDAY
