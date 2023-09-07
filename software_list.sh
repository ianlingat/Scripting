#!/bin/bash
DATE=`date +"%Y-%m-%d"`
HOST=`hostname`

cd ~

echo "Listing all installed software in $HOST" > ~/$DATE-$HOST-listed_packages.csv
echo "============================================================================================" >> ~/$DATE-$HOST-listed_packages.csv
echo "Packages,Version," >> ~/$DATE-$HOST-listed_packages.csv
yum list installed | grep -v "Installed Packages" | sed 's/ /,/g' | sed 's/,\+/,/g' | sed 's/^,//' | sed 's/,$//' >> ~/$DATE-$HOST-listed_packages.csv


echo " " >> ~/$DATE-$HOST-listed_packages.csv
echo "Listing all software that needs to be updated in $HOST" >> ~/$DATE-$HOST-listed_packages.csv
echo "============================================================================================" >> ~/$DATE-$HOST-listed_packages.csv
echo "Packages,Version," >> ~/$DATE-$HOST-listed_packages.csv
yum check-update | grep -v "Last metadata" | sed '1d' | sed 's/ /,/g' | sed 's/,\+/,/g' | sed 's/^,//' | sed 's/,$//' >> ~/$DATE-$HOST-listed_packages.csv


./ossutil64 cp ~/$DATE-$HOST-listed_packages.csv oss://ctvi-bucket/ecs_servers_software_packages/$DATE/

rm -rvf ~/$DATE-$HOST-listed_packages.csv
