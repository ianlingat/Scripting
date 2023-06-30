#!/bin/bash
#Christian Arth Lingat
#04-27-2023

echo Kindly input the file system to be checked:
read filesystem
echo Kindly input the threshold
read threshold

disk_usage=$(df -h | grep $filesystem | awk '{print $5}' | sed 's/%//')

if [[ $disk_usage > $threshold ]]
then
	echo Disk usage of Filesystem $filesystem is greater than $threshold%. Current usage is $disk_usage%.
else
	echo Disk usage is below the input threshold $threshold%. Current usage is $disk_usage%.
fi
