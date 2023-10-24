#!/bin/bash
#/reports/scripts/ossutil64 cp -r /reports/Reports_Passed/ oss://ctvi-bucket/ctvi-reports/

# Set the directory path to check for files
directory_path="/reports/Reports_Passed"

# Set the Alibaba Cloud OSS bucket name
bucket_name="ctvi-bucket/ctvi-reports"

# Set the Alibaba Cloud OSS endpoint
endpoint="https://oss-ap-southeast-6.aliyuncs.com"

files=$(ls "$directory_path")

# Loop through each file in the directory
for file in $files
do
        if [[ $(ossutil ls oss://ctvi-bucket/ctvi-reports/$file --endpoint https://oss-ap-southeast-6.aliyuncs.com | grep "Object Number is:" | awk '{print $4}') == 0 ]]
        then
                echo "Proceeding to transfer file $file in OSS Bucket $bucket_name"
                /reports/scripts/ossutil64 cp /reports/Reports_Passed/$file oss://ctvi-bucket/ctvi-reports/
        else
                echo "File $file already exist on OSS Bucket $bucket_name"
        fi
done
