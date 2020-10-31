#! /bin/bash

set -x -v

filepath=$1

year=$(stat $filepath |grep Modify|awk '{print $2}'|awk -F '-' '{print $1}')
daymonth=$(stat $filepath |grep Modify|awk '{print $2}'|awk -F '-' '{print $2"-"$3}')

if [ $daymonth == "01-01" ]
then
        year=`expr $year - 1`
fi


#mkdir ./mail_report.dir
cd /root/mail_report_new.dir

filename=$(zcat $filepath|awk '{print "'"$year"'""-"$1"-"$2}'|head -1)

touch "log-$filename.csv"

zgrep postfix $filepath > postfix_tmpfile
grep "postfix/qmgr" postfix_tmpfile|grep from|awk '{print $1"\t"$2"\t"$3","$6","$7","$9}'|sed 's/\://3'|sed 's/from=<//g'|sed 's/>,//g'|sed 's/nrcpt=//g'|awk -F',' '{system("echo "$0";date -d \""$1" "'"$year"'"\" \"+%s\"")}'|sed 'N;s/\n/,/'|awk -F "," '{print $NF","$2","$3}'|sort -t ',' -k 2 >senders_tmp

grep "dsn=" postfix_tmpfile|awk -F "status=" '{print $1" "$2}'|sed -e 's/ conn_use=[0-9]*, / /'|sed -e 's/orig_to=<.*>,//g'|awk '{s = ""; for (i = 13; i <= NF; i++) s = s $i " ";system("date -d \""$1" "$2" "$3" "'"$year"'"\" \"+%s\"");print "#B#"$6"#B#"$7"#B#"$11"#B#"s}'|sed 's/://1'|sed 'N;s/\n//'|sed 's/to=<//g'|sed 's/>,//g'|sed 's/,//g'|sed 's/#B#/,/g'|sed 's/dsn=//'|grep -Ev "from MTA\(\[127.0.0.1\]:10025\): 250 2.0.0 Ok: queued as"|sort -t ',' -k 2 >delivery_tmp

join -t ',' -j 2 -o 1.3,2.3,1.1,2.1,1.2,2.4,2.5 senders_tmp delivery_tmp > join_tmp
grep -v "dsn=4" join_tmp >> final_report

#sort -t ',' -k 5 deferred_file > deferred_file_sorted
awk -F"," '!seen[$2, $5]++' deferred_file | sort -t ',' -k 5  > deferred_file_uniqued

join -t ',' -1 5 -2 2 -o 1.1,1.2,1.3,2.1,1.4,2.4,2.5 deferred_file_uniqued delivery_tmp|grep -v "dsn=4" >> "log-$filename.csv"

join -t ',' -1 5 -2 2 -o 1.1,1.2,1.3,2.1,1.5,2.4,2.5 deferred_file_uniqued delivery_tmp|grep "dsn=4"|sort -t ',' -k 5 > deferred_file

grep "dsn=4" join_tmp >>deferred_file
