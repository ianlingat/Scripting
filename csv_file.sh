#!/bin/sh

DATE=$(date +"%Y-%m-%d")
DATE_TODAY=$(date +"%d")
MONTH_DIR=$(date +"%Y%m")

cd SPEEDTEST_REPORT/
mkdir -p $MONTH_DIR/$DATE_TODAY/
cd $MONTH_DIR/$DATE_TODAY/
touch SSI_SPEEDTEST-REPORT_$DATE.csv

echo "SSI Internet Speed Report - $DATE" >> SSI_SPEEDTEST-REPORT_$DATE.csv
echo "DATE-TIME,Download,Upload" >> SSI_SPEEDTEST-REPORT_$DATE.csv
