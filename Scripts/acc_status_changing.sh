#! /bin/bash

#set -x -v

numregex="^-?[0-9]+$"
#---------------------------------------------------
if [ !  -f /opt/Chmail/bin/zmprov ]
then
	echo "run this script in Chmail server!!"
	exit 1
fi
#---------------------------------------------------
if [ -f "/opt/Chmail/log/acc_status_tmp" ]
then
	rm -f  /opt/Chmail/log/acc_status_tmp
fi
#---------------------------------------------------
change_status(){
echo "Please enter the name of your account list file : "
read acc_list
awk '{print "ma "$1" ChmailAccountStatus '$1'"}' $acc_list>>/opt/Chmail/log/acc_status_tmp
/opt/Chmail/bin/zmprov </opt/Chmail/log/acc_status_tmp &> /var/log/test
#clear
echo "It's done!"
}
#---------------------------------------------------
menu(){
clear
echo "Please select one of the account statuses : "
echo -e "\t1)Active"
echo -e "\t2)Closed"
echo -e "\t3)Locked"
echo -e "\t4)Maintenance"
echo -e "\t5)Loclout"
echo -e "\t6)Pending"
echo
echo -n 'Enter your Selection: '
read type
if [ "x$type" = "x" ]
then
        echo "Empty number , Please select one of numbers!!"
        sleep 2
        exit 1
elif [[ $type =~ $numregex && $type -eq "1" ]] ; then
	change_status active
elif [[ $type =~ $numregex && $type -eq "2" ]] ; then
	change_status closed
elif [[ $type =~ $numregex && $type -eq "3" ]] ; then
	change_status locked
elif [[ $type =~ $numregex && $type -eq "4" ]] ; then
	change_status maintenance
elif [[ $type =~ $numregex && $type -eq "5" ]] ; then
	change_status lockout
elif [[ $type =~ $numregex && $type -eq "6" ]] ; then
	change_status pending
elif [[ $type =~ $numregex ]] ; then
	echo "invalid Selection! : $type , press enter key to continue! "
	read
	menu
else
	echo "$type: is not integer,Please select one of available numbers!! , press return key to continue!"
	read
	menu
fi
}
#---------------------------------------------------
menu

