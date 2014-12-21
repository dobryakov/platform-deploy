#!/bin/sh

if [ ! -z "$1" ]
then

dbname=`cat app/config/parameters.yml | grep database_name | sed 's/database_name://g' | sed 's/\s//g'`
dbuser=`cat app/config/parameters.yml | grep database_user | sed 's/database_user://g' | sed 's/\s//g'`
dbpass=`cat app/config/parameters.yml | grep database_password | sed 's/database_password://g' | sed 's/\s//g'`

#s="mysqldump --extended-insert=false -u$dbuser -p$dbpass $dbname > $1"
s="mysqldump -u$dbuser -p$dbpass $dbname > $1"
echo "Executing $s"
eval $s

fi
