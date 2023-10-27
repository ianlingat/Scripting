#!/bin/bash
#/reports/scripts/ossutil64 cp -r /reports/Reports_Passed/ oss://ctvi-bucket/ctvi-reports/

# Define the lock file path
lock_file="/reports/scripts/transfer-to-oss-v4.run"
if [ -e "$lock_file" ]; then
  echo "Script is already running. Exiting."
  exit 1
fi

echo "$$" > "$lock_file"

# Set the variable for the log files
DATE_FILE=`date +"%Y-%m-%d"`

# Set the directory path to check for files
directory_path="/reports/Reports_Passed"

# Set the Alibaba Cloud OSS bucket name
bucket_name="ctvi-bucket/ctvi-reports"

# Set the Alibaba Cloud OSS endpoint
endpoint="https://oss-ap-southeast-6.aliyuncs.com"

files=$(ls "$directory_path")

for file in $files
do
        if [[ $(ossutil ls oss://ctvi-bucket/ctvi-reports/$file --endpoint https://oss-ap-southeast-6.aliyuncs.com | grep "Object Number is:" | awk '{print $4}') == 0 ]]
        then
                DATE_IF=`date +"%Y-%m-%d %H:%M:%S"`
                echo "$DATE_IF Proceeding to transfer file $file in OSS Bucket $bucket_name" >> /reports/transfer-to-oss-logs/transfer-to-oss-v4-$DATE_FILE.log
                /reports/scripts/ossutil64 cp /reports/Reports_Passed/$file oss://ctvi-bucket/ctvi-reports/ >> /reports/transfer-to-oss-logs/transfer-to-oss-v4-$DATE_FILE.log
        else
                DATE_ELSE=`date +"%Y-%m-%d %H:%M:%S"`
                echo "$DATE_ELSE File $file already exist on OSS Bucket $bucket_name" >> /reports/transfer-to-oss-logs/transfer-to-oss-v4-$DATE_FILE.log
        fi
done
rm "$lock_file"
