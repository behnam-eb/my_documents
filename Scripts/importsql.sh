#! /bin/bash
set -xv

cd /opt/Chmail/log/logs-before-import

filename=$(date|awk '{print "log-"$6"-"$2"-"$3".csv"}')
chown Chmail: "$filename"

/opt/Chmail/bin/mysql -u behnam --password=salamsalam -D logtest -e "LOAD DATA INFILE '/opt/Chmail/log/logs-before-import/$filename' INTO TABLE testlog COLUMNS TERMINATED BY ',' LINES TERMINATED BY '\n';" >> mysql.log

tar -cpzf "$filename.tar.gz" "$filename"

mv "$filename.tar.gz" /opt/Chmail/log/logs-after-import/

rm "$filename"
