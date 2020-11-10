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
if [ -f "/opt/Chmail/log/accs_tmp" ]
then
	rm -f  /opt/Chmail/log/accs_tmp
fi
#---------------------------------------------------
#---------------------------------------------------
if [ -f "/opt/Chmail/log/acc_list" ]
then
	rm -f  /opt/Chmail/log/acc_list
fi
#---------------------------------------------------
change_attribute(){
	acc_list=$1
	awk '{print "ma "$1" ChmailPasswordMustChange TRUE"}' $acc_list >>/opt/Chmail/log/accs_tmp
	/opt/Chmail/bin/zmprov </opt/Chmail/log/accs_tmp &> /var/log/test
	#clear
	echo "It's done!"
}
#---------------------------------------------------
menu(){
	clear
	echo "Please select one of  : "
	echo -e "\t1)All accounts"
	echo -e "\t2)Domain accounts"
	echo
	echo -n 'Enter your Selection: '
	read type
	if [ "x$type" = "x" ]
	then
			echo "Empty number , Please select one of numbers!!"
			sleep 2
			exit 1
	elif [[ $type =~ $numregex && $type -eq "1" ]] ; then
		/opt/Chmail/bin/zmprov -l gaa > /opt/Chmail/log/acc_list
		change_attribute /opt/Chmail/log/acc_list
	elif [[ $type =~ $numregex && $type -eq "2" ]] ; then
		menu_domain
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
#---------------------------------------------------
menu_domain(){
	clear
	/opt/Chmail/bin/zmprov gad 
	echo "Enter one domain name :"
	read domain
	/opt/Chmail/bin/zmprov -l gaa -v $domain|grep ChmailMailDeliveryAddress|awk '{print $2}' > /opt/Chmail/log/acc_list
	change_attribute /opt/Chmail/log/acc_list
}
#---------------------------------------------------

menu


