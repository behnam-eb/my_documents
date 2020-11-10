 #!/bin/bash
# set -x -v
    ##Modified by Steve Fink stevef-at-ublug.org
	##This IMAPSync Batch Script is used when you have different
	##usernames on the Source and Destination servers
	##(kinda what IMAPSync was intended for)
	##the format for the user-list.csv file is
	##sourceusername,sourcepassword,destinationusername,destinationpassword 

	infile=$1
	## Get the info
	#	while [ -z $infile ]; do
	#		echo "What is the path to the input file?"
	#		read infile
	#	done
#		while [ -z $host1 ]; do
#			echo "What is the Source Host? (mail1.domain.com)"
#			read host1
#		done
#		while [ -z $host2 ]; do
#			echo "What is the Destination Host? (mail2.domain.com)"
#			read host2
#		done
#		while [ -z $domain1 ]; do
#			echo "What is the Source Domain? (domain.com)"
#			read domain1
#		done
#		while [ -z $domain2 ]; do
#			echo "What is the Destination Domain? (domain.com)"
#			read domain2
#		done
	logfile=$2
	logmigrate=$3
	#	while [ -z $logfile ]; do
	#		echo "Where would you like the log? (synclog.txt)"
	#		read logfile
	#	done

	#	while [ -z $logmigrate ]; do
         #               echo "Where would you like the migrate log? (migratelog.txt)"
         #               read logmigrate
          #      done
		

		if [ ! -f $infile ]
        	then
                	{
				echo "The input file does not exist!"
				echo ""
				echo "What is the path to the input file?"
				read infile
			}
		fi
				
		INPUTFILE=$infile
				
		clear
		echo ""
		echo ""
		echo "IMAPSync is about to begin using:"
		echo "Input File $INPUTFILE"
		echo "Source Host $host1"
		echo "Destination Host $host2"
		echo "Source Domain is $domain1"
		echo "Destination Domain is $domain2"
		echo "Log File $logfile"
		echo ""
		echo ""
		echo "Is this information correct?"
                echo "Press Enter to continue or"
		echo "Hit CTRL+C to start over"
		read wait

	## Begin IMAPSync
		date=`date +%X_-_%x`
		echo "IMAPSync Logfile started @ $logfile"
		echo "" >> $logfile
		echo "------------------------------------" >> $logfile
    		echo "IMAPSync started..  $date" >> $logfile
    		echo "" >> $logfile

	#Get rid of the commas
		tr "," " " <$INPUTFILE | while read u1 p1 u2 p2
			do
				user1=$u1
				user2=$u2
				
             	echo "Syncing User $user1 to $user2"
            	date=`date +%X_-_%x`
            	echo "Start Syncing User $user1 to $user2"
            	echo "Starting $u1 $date" >> $logfile
    			##--nosyncacls --syncinternaldates ##--skipsize
		        imapsync \
				--regextrans2 "s/^Sent$/Sent/" \
                                --regextrans2 "s/^INBOX$/INBOX/" \
                                --regextrans2 's/^Drafts$/Drafts/' \
				--exclude "Trash" \
 --host1 192.168.151.169  --user1 "$user1" --password1 "$p1"   --host2 192.168.151.50   --user2 "$user2" --password2 "$p2" >>$logmigrate
				
				date=`date +%X_-_%x`

				echo "User $user1 to $user2 done"
				echo "Finished $user1 to $user2 $date" >> $logfile
				echo "" >> $logfile
            done

    		date=`date +%X_-_%x`

    		echo "" >> $logfile
    		echo "IMAPSync Finished..  $date" >> $logfile
    		echo "------------------------------------" >> $logfile
