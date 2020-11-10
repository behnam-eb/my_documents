date 
echo 'threads run: ' ; ps ax | grep migrate | grep -v grep | awk {'print $6 , $7'} | sort | uniq | wc -l
echo 'all users: ' ; wc -l alluser | tail -n 1 
echo 'Old mail avilable mailbox size: ' ; grep -r 'Host1 Total size' * --exclude-dir=LOG_imapsync | awk '{sum+=$4} END {print sum/1024/1024/1024 , " GB"} '
echo 'New mail transferred mailbox size: ' ; grep -r 'Host2 Total size' * --exclude-dir=LOG_imapsync | awk '{sum+=$4} END {print sum/1024/1024/1024 , " GB"}'
echo 'users that sync started: ' ; grep -r 'Start Syncing User' * --exclude-dir=LOG_imapsync | wc -l  
 echo 'users synced: ' ; grep -r '++++ Statistics' * --exclude-dir=LOG_imapsync |grep -v LOG_imapsync| wc -l        
 echo 'users failed: ' ; grep -r -i failed * --exclude-dir=LOG_imapsync | grep '192.168'  | grep -v LOG_imapsync | wc -l              
 grep -i -r 'Total bytes error' * --exclude-dir=LOG_imapsync|  awk '{sum+=$5} END {print sum/1024/1024 " MB Errors"}'
 grep -i -r 'Biggest message' * --exclude-dir=LOG_imapsync|  awk {'print $4'} | sort -n | tail -n 1 | awk {'print $1 /1024/1024 " MB Biggest massge" '}
grep -i -r 'Messages skipped' * --exclude-dir=LOG_imapsync |  awk '{sum+=$4} END {print sum " Messages skipped" }'
grep -i -r 'Total bytes skipped' *  --exclude-dir=LOG_imapsync |  awk '{sum+=$5} END {print sum/1024/1024/1024 " GB Skipped"}'
grep -i -r 'Messages transferred' * --exclude-dir=LOG_imapsync |  awk '{sum+=$4} END {print sum " messages transferred "}'
grep -i -r 'Total bytes transferred' * --exclude-dir=LOG_imapsync |  awk '{sum+=$5} END {print sum/1024/1024/1024 " GB Transferred"}'
