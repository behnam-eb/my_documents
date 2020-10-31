#! /bin/bash
#set -x -v
user=`id -u`;

# email address regex
regex="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

# number regex
numregex="^-?[0-9]+$"
#numregex1="^([0-9]+,?)+$"
#numregex1="^([1-9]|1[0-3])(,([1-9]|1[0-3]))*,?$"
numregex1="^([1-9]|1[0-3])(,([1-9]|1[0-3]))*$"
# check owner
if [ ! $user == '0' ]
then
       echo 'Permission Denied , you must run this script with root permission'
	exit 1

fi

# Is Chmail server or not?!
if [ !  -f /opt/Chmail/bin/zmprov ]
then
	echo run this script in Chmail server!!
	exit 1
fi

# lock process to avoid duplicate running at the same time
if [ -f "/opt/Chmail/log/report.pid" ]
        then
        MYPID=`head -n 1 "/opt/Chmail/log/report.pid"`
        TEST_RUNNING=`ps -p ${MYPID} | grep ${MYPID}`
        if [ -z "${TEST_RUNNING}" ]
                then
                echo $$ > "/opt/Chmail/log/report.pid"
        else
        echo "the process is running!"
        exit 0
        fi
else
        echo $$ > "/opt/Chmail/log/report.pid"
fi

path=`pwd`
touch $path/outfile
FILE=$path/outfile
FFILE=$1
mkdir $path/report_result &> /dev/null

getAalUser(){
clear
echo -e "1)Export All account mail addresses "
#echo -e "2)Export All account mailAddress & PersonalCode & Firstname & Lastname "
echo -e "2)Export base on specific attribute "
echo '3)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	rm -f $path/report_result/AlluserMailAddresses &> /dev/null
	echo MailAddress >> $path/report_result/AlluserMailAddresses
	/opt/Chmail/bin/zmprov -l gaa | tee -a $path/report_result/AlluserMailAddresses
	read -p "All user mailaddresses: see $path/report_result/AlluserMailAddresses file for more info,press return key to continue!"
	
# elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	# rm -f /tmp/All &> /dev/null
	# rm -f $path/report_result/AlluserInfo &> /dev/null
	# /opt/Chmail/bin/zmprov -l gaa >> /tmp/All
	# rm -f /tmp/All1 &> /dev/null
	# awk -v sq="'" '{print "/opt/Chmail/bin/zmprov -l ga " 'sq'$0'sq' " ChmailMailDeliveryAddress givenName sn ChmailPersonalCode|grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' "}' /tmp/All > /tmp/All1
	# chmod +x /tmp/All1
	# rm -f /tmp/All2 &> /dev/null
	# /tmp/All1 > /tmp/All2
	# rm -f /tmp/All &> /dev/null
	# echo >> $path/report_result/AlluserInfo
	# echo " mailAddress , personalCode , firstName , lastName" >> $path/report_result/AlluserInfo
	# echo >> $path/report_result/AlluserInfo
	# while read line
	# do
		# findfirst=`echo $line | grep givenName:`
		# findlast=`echo $line | grep sn:`
		# findcode=`echo $line | grep ChmailPersonalCode:`
		# if [ "$findfirst" = "" ] && [ "$findlast" = "" ]; then
			# echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ ChmailPersonalCode: /,/g' | sed 's/$/,,/'| tee -a $path/report_result/AlluserInfo
		# elif [ "$findfirst" = "" ] && [ "$findcode" = "" ]; then
			# echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ sn: /,,,/g'| tee -a $path/report_result/AlluserInfo
		# elif [ "$findlast" = "" ] && [ "$findcode" = "" ]; then
			# echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ givenName: /,,/g'| sed 's/$/,/'| tee -a $path/report_result/AlluserInfo
		# elif [  "$findfirst" = "" ]; then
			# echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ sn: /,,/g' | sed 's/ ChmailPersonalCode: /,/g' | sed 's/ ,/,/g' | tee -a $path/report_result/AlluserInfo
		# elif [  "$findlast" = "" ]; then
			# echo $line, | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ givenName: /,/g' | sed 's/ ChmailPersonalCode: /,/g' | sed 's/ ,/,/g' | tee -a $path/report_result/AlluserInfo
		# elif [  "$findcode" = "" ]; then
			# echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ givenName: /,,/g'| sed 's/ sn: /,/g' | sed 's/ ,/,/g' | tee -a $path/report_result/AlluserInfo
		# else
			# echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ ChmailPersonalCode: /,/g'| sed 's/ givenName: /,/g'| sed 's/ sn: /,/g'| tee -a $path/report_result/AlluserInfo
		# fi
	# done < /tmp/All2
	# rm -f /tmp/All2 &> /dev/null
	# rm -f /tmp/All1 &> /dev/null
	# echo -n "All User: see $path/report_result/AlluserInfo file for all accounts ,press return key to continue!"
	# read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
rm -f $path/report_result/AlluserInfo &> /dev/null
#echo > $path/report_result/Alluserinfo
echo > /tmp/1
echo
	echo -e "1)mailAddress, 2)display name, 3)firstName, 4)lastName, 5)Personal code, 6)Personal type, 7)City, 8)description, 9)National code, 10)Identification code, 11)Mobile, 12)Education center, 13)Education field"
echo -n "you can select any list of above number ,you should seprate with comma e.g 1,3,6,7 : "
string=""
str=""
str1=""
stri=""
read string
if [ "x$string" = "x" ]
then
        echo "select numbers!!"
        sleep 2
	getAalUser
elif [[ $string =~ $numregex1 ]] ; then

Allargs=( ChmailMailDeliveryAddress displayName givenName sn ChmailPersonalCode ChmailPersonalType l description ChmailMelliCode ChmailIdentifireCode mobile ChmailEducationCenter ChmailEducationField )
Allargs1=( mailAddress displayName firstName lastName PersonalCode PersonalType City description NationalCode IdCode mobile EducationCenter EducationField )
IFS=',' read -a array <<< "$string"
for index in "${array[@]}"
do
    str="$str "${Allargs[$index-1]}
    str1="$str1"${Allargs1[$index-1]}","
done
echo "$str1" | tee -a $path/report_result/AlluserInfo
isExist=""
read -a arr <<< "$str"
for user in `/opt/Chmail/bin/zmprov -l gaa`
do
        /opt/Chmail/bin/zmprov ga $user $str |grep -v "#" > /tmp/1
        stri=""
        for element in "${arr[@]}"
        do
                isExist=`grep -w $element: /tmp/1`
                if [ "$isExist" = "" ]; then
                        stri="$stri,"
                else
                        sep=`echo $isExist | sed "s/$element: //g"`

                        stri="$stri$sep,"
                fi
        done
        echo $stri | tee -a $path/report_result/AlluserInfo
        done

        read -p "All User: see $path/report_result/AlluserInfo file for all accounts ,press return key to continue!"
        
else
        echo "invalid stream selection! : $string"
	sleep 4 
        getAalUser
fi
elif [[ $choice =~ $numregex && $choice -eq "3" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getAalUser
fi
getAalUser
}



getNtCode(){
clear
echo -e "1)Export account mail addresses from National code "
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE  | sed 's/\r$//'  | grep -v '^$' > $FILE
		#echo >> $FILE	
	fi
	rm -f $path/report_result/nationalCodeinfo &> /dev/null	
	rm -f /opt/Chmail/log/Ntcode &> /dev/null	
	rm -f /tmp/Ntuser
	rm -f /tmp/findNt 
	echo >> $path/report_result/nationalCodeinfo
	echo " MailAddress , NationalCode " >> $path/report_result/nationalCodeinfo
	echo >> $path/report_result/nationalCodeinfo

	awk -v sq="'"  '{print " sa "sq"(ChmailMelliCode="$0")"sq}' $FILE > /opt/Chmail/log/Ntcode
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/Ntcode | sed 's/prov> //g' >> /tmp/Ntuser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress ChmailMelliCode |grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ ChmailMelliCode: /,/g'\'' " }' /tmp/Ntuser  > /tmp/findNt
	chmod +x /tmp/findNt
	/tmp/findNt | tee -a $path/report_result/nationalCodeinfo
	rm -f /opt/Chmail/log/Ntcode &> /dev/null
	rm -f /tmp/Ntuser
	rm -f /tmp/findNt 
	echo -e "\nNational code: see $path/report_result/nationalCodeInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getNtCode
fi
getNtCode
}

getIDcode(){
clear
echo -e "1)Export account mail addresses from Identification code "
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//' | grep -v '^$' > $FILE	
		#echo >> $FILE	
	fi
	rm -f $path/report_result/identificationCodeInfo &> /dev/null	
	rm -f /opt/Chmail/log/IDcode &> /dev/null
	rm -f /tmp/IDuser &> /dev/null
	rm -f /tmp/findId &> /dev/null
	echo >> $path/report_result/identificationCodeInfo
	echo " MailAddress , IdentificationCode " >> $path/report_result/identificationCodeInfo
	echo >> $path/report_result/identificationCodeInfo

	awk -v sq="'"  '{print " sa "sq"(ChmailIdentifireCode="$0")"sq}' $FILE > /opt/Chmail/log/IDcode
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/IDcode | sed 's/prov> //g' >> /tmp/IDuser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress ChmailIdentifireCode |grep -v \"#\" |tac|" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' | sed '\''s/ ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ ChmailIdentifireCode: /,/g'\'' " }' /tmp/IDuser  > /tmp/findId
	chmod +x /tmp/findId
	/tmp/findId | tee -a $path/report_result/identificationCodeInfo

	rm -f /opt/Chmail/log/IDcode &> /dev/null
	rm -f /tmp/IDuser
	rm -f /tmp/findId 
	echo -e "\nIdentification code: see $path/report_result/identificationCodeInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getIDcode
fi
getIDcode
}

getPcode(){
clear
echo -e "1)Export account mail addresses from Personal code "
echo -e "2)Export mailAddress & PersonalCode & Firstname & Lastname "
echo '3)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$' > $FILE	
		#echo >> $FILE	
	fi
	rm -f $path/report_result/personalCodeMailaddresses &> /dev/null
	rm -f /opt/Chmail/log/Pcode &> /dev/null	
	rm -f /tmp/findP &> /dev/null
	rm -f /tmp/Puser &> /dev/null
	echo >> $path/report_result/personalCodeMailaddresses
	echo " MailAddress , PersonalCode " >> $path/report_result/personalCodeMailaddresses
	echo >> $path/report_result/personalCodeMailaddresses
	awk -v sq="'"  '{print " sa "sq"(ChmailPersonalCode="$0")"sq}' $FILE > /opt/Chmail/log/Pcode
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/Pcode | sed 's/prov> //g' >> /tmp/Puser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress ChmailPersonalCode |grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ ChmailPersonalCode: /,/g'\'' " }' /tmp/Puser  > /tmp/findP
	chmod +x /tmp/findP
	/tmp/findP | tee -a $path/report_result/personalCodeMailaddresses
	rm -f /tmp/findP &> /dev/null
	rm -f /tmp/Puser &> /dev/null
	rm -f /opt/Chmail/log/Pcode &> /dev/null

	rm -f /opt/Chmail/log/Pcode &> /dev/null	
	echo -e "\nPersonal code: see $path/report_result/personalCodeMailaddresses file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$' > $FILE	
		#echo >> $FILE	
	fi
	rm -f $path/report_result/personalCodeInfo
	rm -f /tmp/Puserinfo &> /dev/null
	rm -f /opt/Chmail/log/Pcode &> /dev/null	
	rm -f /tmp/findcode1 &> /dev/null
	rm -f /tmp/findcode &> /dev/null
	echo >> $path/report_result/personalCodeInfo
	echo " mailAddress , personalCode , firstName , lastName" >> $path/report_result/personalCodeInfo
	echo >> $path/report_result/personalCodeInfo
	awk -v sq="'" '{print " sa "sq"(ChmailPersonalCode="$0")"sq}' $FILE > /opt/Chmail/log/Pcode
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/Pcode| sed 's/prov> //g' >> /tmp/Puserinfo
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress givenName sn ChmailPersonalCode|grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' "}' /tmp/Puserinfo > /tmp/findcode
	chmod +x /tmp/findcode
	/tmp/findcode > /tmp/findcode1

	while read line
	do
	findfirst=`echo $line | grep givenName:`
	findlast=`echo $line | grep sn:`
	findcode=`echo $line | grep ChmailPersonalCode:`
	if [ "$findfirst" = "" ] && [ "$findlast" = "" ]; then
		echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ ChmailPersonalCode: /,/g' | sed 's/$/,,/'| tee -a $path/report_result/personalCodeInfo
	elif [ "$findfirst" = "" ] && [ "$findcode" = "" ]; then
		echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ sn: /,,,/g'| tee -a $path/report_result/personalCodeInfo
	elif [ "$findlast" = "" ] && [ "$findcode" = "" ]; then
		echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ givenName: /,,/g'| sed 's/$/,/'| tee -a $path/report_result/personalCodeInfo
	elif [  "$findfirst" = "" ]; then
		echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ sn: /,,/g' | sed 's/ ChmailPersonalCode: /,/g' | sed 's/ ,/,/g' | tee -a $path/report_result/personalCodeInfo
	elif [  "$findlast" = "" ]; then
		echo $line, | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ givenName: /,/g' | sed 's/ ChmailPersonalCode: /,/g' | sed 's/ ,/,/g' | tee -a $path/report_result/personalCodeInfo
	elif [  "$findcode" = "" ]; then
		echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ givenName: /,,/g'| sed 's/ sn: /,/g' | sed 's/ ,/,/g' | tee -a $path/report_result/personalCodeInfo
	else
		echo $line | sed 's/ChmailMailDeliveryAddress: //g' | sed 's/ ChmailPersonalCode: /,/g'| sed 's/ givenName: /,/g'| sed 's/ sn: /,/g'| tee -a $path/report_result/personalCodeInfo
	fi	
	done < /tmp/findcode1
	rm -f /tmp/Puserinfo &> /dev/null
	rm -f /opt/Chmail/log/Pcode &> /dev/null	
	rm -f /tmp/findcode1 &> /dev/null
	rm -f /tmp/findcode &> /dev/null
	echo -e "\nPersonal code: see $path/report_result/personalCodeInfo file for file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "3" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getPcode
fi
getPcode
}

getMobile(){
clear
echo -e "1)Export account mail addresses from Mobile number "
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$'  > $FILE	
		#echo >> $FILE	
	fi
	rm -f $path/report_result/mobileInfo &> /dev/null	
	rm -f /opt/Chmail/log/Mobile &> /dev/null	
	rm -f /tmp/Mobileuser &> /dev/null
	rm -f /tmp/findMobile &> /dev/null
	echo >> $path/report_result/mobileInfo
	echo " MailAddress , Mobile " >> $path/report_result/mobileInfo
	echo >> $path/report_result/mobileInfo

	awk -v sq="'"  '{print " sa "sq"(mobile="$0")"sq}' $FILE > /opt/Chmail/log/Mobile
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/Mobile | sed 's/prov> //g' >> /tmp/Mobileuser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress mobile |grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ mobile: /,/g'\'' " }' /tmp/Mobileuser  > /tmp/findMobile
	chmod +x /tmp/findMobile
	/tmp/findMobile | tee -a $path/report_result/mobileInfo
	
	rm -f /opt/Chmail/log/Mobile &> /dev/null	
	rm -f /tmp/Mobileuser &> /dev/null
	rm -f /tmp/findMobile &> /dev/null
	echo -e "\nMobile: see $path/report_result/mobileInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getMobile
fi
getMobile
}

getFirst(){
clear
echo -e "1)Export account mail addresses from Firstname "
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$' > $FILE	
		#echo >> $FILE	
	fi
	rm -f $path/report_result/firstInfo &> /dev/null
	rm -f /tmp/Firstuser &> /dev/null
	rm -f /opt/Chmail/log/First &> /dev/null	
	rm -f /tmp/findFirst &> /dev/null
	echo >> $path/report_result/firstInfo
	echo " mailAddress , firstName " >> $path/report_result/firstInfo
	echo >> $path/report_result/firstInfo
	awk -v sq="'"  '{print " sa "sq"(givenName="$0")"sq}' $FILE > /opt/Chmail/log/First
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/First | sed 's/prov> //g' >> /tmp/Firstuser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress givenName |grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ givenName: /,/g'\'' " }' /tmp/Firstuser  > /tmp/findFirst
	chmod +x /tmp/findFirst
	/tmp/findFirst | tee -a $path/report_result/firstInfo
	rm -f /tmp/Firstuser &> /dev/null
	rm -f /opt/Chmail/log/First &> /dev/null	
	rm -f /tmp/findFirst &> /dev/null
	echo -e "\nFirstname: see $path/report_result/firstInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getFirst
fi
getFirst
}

getLast(){
clear
echo -e "1)Export account mail addresses from Lastname "
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$' > $FILE	
		#echo >> $FILE	
	fi
	rm -f $path/report_result/lastInfo &> /dev/null
	rm -f /tmp/Lastuser &> /dev/null
	rm -f /opt/Chmail/log/Last &> /dev/null	
	rm -f /tmp/findLast &> /dev/null
	echo >> $path/report_result/lastInfo
	echo " mailAddress , lastName " >> $path/report_result/lastInfo
	echo >> $path/report_result/lastInfo
	awk -v sq="'"  '{print " sa "sq"(sn="$0")"sq}' $FILE > /opt/Chmail/log/Last
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/Last | sed 's/prov> //g' >> /tmp/Lastuser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress sn |grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ sn: /,/g'\'' " }' /tmp/Lastuser  > /tmp/findLast
	chmod +x /tmp/findLast
	/tmp/findLast | tee -a $path/report_result/lastInfo

	rm -f /tmp/Lastuser &> /dev/null
	rm -f /opt/Chmail/log/Last &> /dev/null	
	rm -f /tmp/findLast &> /dev/null
	echo -e "\nLastname: see $path/report_result/lastInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getLast
fi
getLast
}

getFirstLast(){
clear
echo -e "1)Export account mail addresses from First & lastname"
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$' > $FILE
	   # echo >> $FILE	
	fi
	rm -f /tmp/FirstLastuser &> /dev/null	
	rm -f /opt/Chmail/log/FirstLast &> /dev/null
	rm -f  $path/report_result/firstLastInfo &> /dev/null
	rm -f /tmp/findFirstLast &> /dev/null
	echo >> $path/report_result/firstLastInfo
	echo " MailAddress , First , LastName " >> $path/report_result/firstLastInfo
	echo >> $path/report_result/firstLastInfo

	awk -F "," -v sq="'" '{print " sa "sq"&((givenName="$1")(sn="$2"))"sq}' $FILE > /opt/Chmail/log/FirstLast
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/FirstLast | sed 's/prov> //g' >> /tmp/FirstLastuser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress givenName sn |grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ givenName: /,/g'\'' | sed '\''s/ sn: /,/g'\'' " }' /tmp/FirstLastuser  > /tmp/findFirstLast
	chmod +x /tmp/findFirstLast
	/tmp/findFirstLast | tee -a $path/report_result/firstLastInfo

	rm -f /tmp/FirstLastuser &> /dev/null	
	rm -f /opt/Chmail/log/FirstLast &> /dev/null
	rm -f /tmp/findFirstLast &> /dev/null

	echo -e "\nFirst,lastname: see $path/report_result/firstLastInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getFirstLast
fi
getFirstLast
}


getPtype(){
clear
echo -e "1)Export account mail addresses from Personal type "
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$' > $FILE
		#echo >> $FILE	
	fi
	rm -f $path/report_result/personalTypeInfo &> /dev/null
	rm -f /tmp/Ptypeuser &> /dev/null	
	rm -f /opt/Chmail/log/Ptype &> /dev/null
	rm -f /tmp/findP &> /dev/null
	echo >> $path/report_result/personalTypeInfo
	echo " mailAddress , personalType " >> $path/report_result/personalTypeInfo
	echo >> $path/report_result/personalTypeInfo
	awk -v sq="'"  '{print " sa "sq"(ChmailPersonalType="$0")"sq}' $FILE > /opt/Chmail/log/Ptype
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/Ptype | sed 's/prov> //g' >> /tmp/Ptypeuser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress ChmailPersonalType |grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ ChmailPersonalType: /,/g'\'' " }' /tmp/Ptypeuser  > /tmp/findP
	chmod +x /tmp/findP
	/tmp/findP | tee -a $path/report_result/personalTypeInfo

	rm -f /tmp/Ptypeuser &> /dev/null	
	rm -f /opt/Chmail/log/Ptype &> /dev/null
	rm -f /tmp/findP &> /dev/null

	echo -e "\nPersonal type: see $path/report_result/personalTypeInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getPtype
fi
getPtype
}

getEdCenter(){
clear
echo -e "1)Export account mail addresses from Education center "
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$'  > $FILE	
		#echo >> $FILE	
	fi
	rm -f $path/report_result/educationCenterInfo &> /dev/null
	rm -f /tmp/EdCenteruser	&> /dev/null
	rm -f /opt/Chmail/log/EdCenter &> /dev/null
	rm - f /tmp/findEd &> /dev/null
	echo >> $path/report_result/educationCenterInfo
	echo " mailAddress , educationCenter " >> $path/report_result/educationCenterInfo
	echo >> $path/report_result/educationCenterInfo
	awk -v sq="'"  '{print "sa "sq"(ChmailEducationCenter="$0")"sq}' $FILE > /opt/Chmail/log/EdCenter
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/EdCenter | sed 's/prov> //g' >> /tmp/EdCenteruser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress ChmailEducationCenter |grep -v \"#\" |tac|" "sed '\''{:q;N;s/'"\\\n"'//g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ChmailEducationCenter: /,/g'\'' " }' /tmp/EdCenteruser  > /tmp/findEd
	chmod +x /tmp/findEd
	/tmp/findEd | tee -a $path/report_result/educationCenterInfo

	rm -f /tmp/EdCenteruser	&> /dev/null
	rm -f /opt/Chmail/log/EdCenter &> /dev/null
	rm - f /tmp/findEd &> /dev/null

	echo -e "\nEducation center: see $path/report_result/educationCenterInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getEdCenter
fi
getEdCenter
}

getEdfield(){
clear
echo -e "1)Export account mail addresses from Education field "
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$' > $FILE	
		#echo >> $FILE	
	fi
	rm -f $path/report_result/educationFieldInfo &> /dev/null
	rm -f /tmp/Edfielduser	&> /dev/null
	rm -f /opt/Chmail/log/Edfield &> /dev/null
	rm -f /tmp/findEdf &> /dev/null
	echo >> $path/report_result/educationFieldInfo
	echo " mailAddress , educationField " >> $path/report_result/educationFieldInfo
	echo >> $path/report_result/educationFieldInfo
	awk -v sq="'"  '{print "sa "sq"(ChmailEducationField="$0")"sq}' $FILE > /opt/Chmail/log/Edfield
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/Edfield | sed 's/prov> //g' >> /tmp/Edfielduser
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress ChmailEducationField |grep -v \"#\" |tac|" "sed '\''{:q;N;s/'"\\\n"'//g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ChmailEducationField: /,/g'\'' " }' /tmp/Edfielduser  > /tmp/findEdf
	chmod +x /tmp/findEdf
	/tmp/findEdf | tee -a $path/report_result/educationFieldInfo

	rm -f /tmp/Edfielduser	&> /dev/null
	rm -f /opt/Chmail/log/Edfield &> /dev/null
	rm -f /tmp/findEdf &> /dev/null

	echo -e "\nEducation field: see $path/report_result/educationFieldInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getEdfield
fi
getEdfield
}

getLocal(){
clear
echo -e "1)Export account mail addresses from City "
echo '2)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | grep -v '^$' | sed 's/\r$//' > $FILE	
		#echo >> $FILE	
	fi
	rm -f $path/report_result/cityInfo &> /dev/null
	rm -f /tmp/userCity &> /dev/null
	rm -f /opt/Chmail/log/Local &> /dev/null
	rm -f /tmp/findCity  &> /dev/null

	echo >> $path/report_result/cityInfo
	echo " mailAddress , City " >> $path/report_result/cityInfo
	echo >> $path/report_result/cityInfo
	awk -v sq="'"  '{print "sa "sq"(l="$0")"sq}' $FILE > /opt/Chmail/log/Local
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/Local | sed 's/prov> //g' >> /tmp/userCity
	awk -v sq="'" '{print "/opt/Chmail/bin/zmprov ga " 'sq'$0'sq' " ChmailMailDeliveryAddress l |grep -v \"#\" |" "sed '\''{:q;N;s/'"\\\n"'/ /g;t q}'\'' | sed '\''s/ChmailMailDeliveryAddress: //g'\'' | sed '\''s/ l: /,/g'\'' " }' /tmp/userCity  > /tmp/findCity
	chmod +x /tmp/findCity
	/tmp/findCity | tee -a $path/report_result/cityInfo

	rm -f /tmp/userCity &> /dev/null
	rm -f /opt/Chmail/log/Local &> /dev/null
	rm -f /tmp/findCity  &> /dev/null

	echo -e "\nLocality: see $path/report_result/cityInfo file for more info,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getLocal
fi
getLocal
}

getQuota(){
clear
echo -e "1)Export Specific account qouta usage: "
echo -e "2)Export All account quota usage: "
echo '3)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	echo -en "enter username  <username@domain.com> : "
	read usern
	if [ "x$usern" = "x" ] ; then
		read -p "empty user mailAddress! , press return key to continue!"
	elif [[ $usern =~ $regex ]] ; then

		/opt/Chmail/bin/zmprov ga $usern &> /dev/null
		usercheck=`echo $?`
			if [ "$usercheck" -ne "0" ]
			then
				read -p "No such $userid1 account exist! press return key to continue ..."
			else
				/opt/Chmail/bin/zmprov gqu `/opt/Chmail/bin/zmhostname`|grep $usern|awk {'print $1" "$3" "$2'} | sort | while read line
			do
				usage=`echo $line|cut -f2 -d " "`
				quota=`echo $line|cut -f3 -d " "`
				user=`echo $line|cut -f1 -d " "`
				echo "MailAddress usedQouta AvailableQuota (note: 0Kb AvailableQuota means unlimite)"
				echo "$user `expr $usage / 1024`Kb `expr $quota / 1024`Kb" 
			done
				read -p "press return key to continue!"
			fi

	else
		read -p "invalid mailAddress: $usern , press return key to continue!"
	fi

elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	rm -f $path/report_result/accountUsage &> /dev/null
	echo "MailAddress usedQouta AvailableQuota" >> $path/report_result/accountUsage
	echo "MailAddress usedQouta AvailableQuota (note: 0Kb AvailableQuota means unlimite)"
	/opt/Chmail/bin/zmprov gqu `/opt/Chmail/bin/zmhostname` |awk {'print $1" "$3" "$2'}| sort | while read line
	do
		usage=`echo $line|cut -f2 -d " "`
		quota=`echo $line|cut -f3 -d " "`
		user=`echo $line|cut -f1 -d " "`
		echo -e "$user `expr $usage / 1024`Kb `expr $quota / 1024`Kb" | tee -a $path/report_result/accountUsage
	done
	read -p "All Qouta usage exported to $path/report_result/accountUsage file , press return key to continue!"
elif [[ $choice =~ $numregex && $choice -eq "3" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	getQuota
fi
getQuota
}

getDate(){
startD="start"
endD="end"
n=0
correctS=1
correctE=1
while [ "$correctS" -ne "0" ]; do
	read -p "enter start date , e.g 20100102 or 2010-01-02 or 01/02/10: " startD
	if [ ! "x$startD" = "x" ]
	then
		date "+%d/%m/%Y" -d "$startD" > /dev/null 2>&1
		correctS=`echo $?`
		if [ "$correctS" -ne "0" ]
		then
			echo invalid Date!
		fi
	else
		echo invalid Date!
	fi
done

while [ "$correctE" -ne "0" ]; do
	read -p "enter end date , e.g 20100102 or 2010-01-02 or 01/02/10: " endD 
	if [ ! "x$endD" = "x" ]
	then
		date "+%d/%m/%Y" -d "$endD" > /dev/null 2>&1
		correctE=`echo $?`
		if [ "$correctE" -ne "0" ]
		then
			echo invalid Date!
		fi
	else
		echo invalid Date!
	fi
done

inputdate=`date -d "$startD" +%D`
enddate=`date -d "$endD" +%D`
ext=""
while [[ ! "$ext" = "$enddate" ]]
do
	
	ext=`echo $(date -d "$inputdate +$n day" "+%D")`
	let n++
	#echo $TIME_EXP
	grep $ext $TIME_EXP | tee -a $TFILE
done
TIME_EXP=""
}

getTime(){
clear
echo -e "1)Export users base on create time\n"
echo -e "2)Export users base on login time\n"
echo "3)Main menu"
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [ x"$choice" = "x" ]
then
	echo "Please enter your selection! "
	exit 1
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	rm -f $path/report_result/createTime &> /dev/null
	TFILE=$path/report_result/createTime
	echo  >> $TFILE 
	echo " mailAddress createDate createTime " >> $TFILE
	echo  >> $TFILE
	TIME_EXP=""
	 su - Chmail -c 'zmaccts' | awk '{print $1 , $3 , $4}' > /tmp/cru
	#/opt/Chmail/bin/zmaccts | awk '{print $1 , $3 , $4}' > /tmp/cru
	TIME_EXP=/tmp/cru
	getDate
	rm -f /tmp/cru &> /dev/null
	read -p "All createTime user exported to $path/report_result/createTime file , press return key to continue!"
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	rm -f $path/report_result/loginTime &> /dev/null
	TFILE=$path/report_result/loginTime
	echo  >> $TFILE
	echo " mailAddress loginDate loginTime " >> $TFILE
	echo  >> $TFILE
	TIME_EXP=""
	su - Chmail -c 'zmaccts' | awk '{print $1 , $5 , $6 }' > /tmp/lu
	# /opt/Chmail/bin/zmaccts | awk '{print $1 , $5 , $6 }' > /tmp/lu
	TIME_EXP=/tmp/lu
	getDate
	rm -f /tmp/lu &> /dev/null
	read -p "All loginTime user exported to $path/report_result/loginTime file , press return key to continue!"
elif [[ $choice =~ $numregex && $choice -eq "3" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 3
	getTime
fi
getTime
}

getStatus(){
clear
echo -e "1)All users status\n"
echo -e "2)Specific user status\n"
echo "3)Main menu"
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [ x"$choice" = "x" ]
then
	echo "Please enter your selection! "
	exit 1
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	rm -f /tmp/users* &> /dev/null
	echo ----------- active users-------------
	/opt/Chmail/bin/zmprov  sa ChmailAccountStatus=active | tee $path/report_result/usersActive
	echo "number of active accounts is :      "`cat $path/report_result/usersActive	 | wc -l`
	echo ----------- lockout users------------
	/opt/Chmail/bin/zmprov  sa ChmailAccountStatus=lockout | tee $path/report_result/usersLockout
	echo "number of lockout accounts is :     "`cat $path/report_result/usersLockout | wc -l`
	echo ----------- locked users-------------
	/opt/Chmail/bin/zmprov  sa ChmailAccountStatus=locked | tee $path/report_result/usersLocked
	echo "number of locked accounts is :      "`cat $path/report_result/usersLocked | wc -l`
	echo ----------- maintenance users--------
	/opt/Chmail/bin/zmprov  sa ChmailAccountStatus=maintenance | tee $path/report_result/usersMaintenance
	echo "number of maintenance accounts is : "`cat $path/report_result/usersMaintenance | wc -l`
	echo ----------- pending users------------
	/opt/Chmail/bin/zmprov  sa ChmailAccountStatus=pending | tee $path/report_result/usersPending
	echo "number of pending accounts is :     "`cat $path/report_result/usersPending | wc -l`
	echo ----------- closed users-------------
	/opt/Chmail/bin/zmprov  sa ChmailAccountStatus=closed | tee $path/report_result/usersClosed
	echo "number of closed accounts is :      "`cat $path/report_result/usersClosed | wc -l`
	echo ---------- failedlogin users---------
	/opt/Chmail/bin/zmprov  sa ChmailAccountStatus=failedlogin | tee $path/report_result/usersFailedlogin
	echo "number of failedlogin accounts is : "`cat $path/report_result/usersFailedlogin | wc -l`
	echo -------------------------------------
	read -p "All Accountlist exported to $path/report_result/user* files , press return key to continue!"
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	echo -en "enter username  <username@domain.com> : "
	read usern
	if [ "x$usern" = "x" ] ; then
		read -p "empty user mailAddress! , press return key to continue!"
	elif [[ $usern =~ $regex ]] ; then
		/opt/Chmail/bin/zmprov ga $usern &> /dev/null
		usercheck=`echo $?`
                if [ "$usercheck" -ne "0" ]
                        then
                	        read -p "No such $usern account exist! press return key to continue ..."
                else
				echo $usern Account status : `/opt/Chmail/bin/zmprov sa -v ChmailMailDeliveryAddress=$usern | grep ChmailAccountStatus: | sed 's/ChmailAccountStatus: //g'` , press return key to continue!
				read
		fi
	else
		read -p "invalid mailAddress: $usern , press return key to continue!"
		
	fi
elif [[ $choice =~ $numregex && $choice -eq "3" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 3
	getStatus
fi
getStatus
}

getGroupStatus(){
clear
echo -e "1)All users group\n"
echo -e "2)Specific group\n"
echo -e "3)Specific user\n"
echo "4)Main menu"
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [ x"$choice" = "x" ]
then
	echo "Please enter your selection! "
	exit 1
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	rm -f $path/report_result/allGroup &> /dev/null
	/opt/Chmail/bin/zmprov -l gadl -v | grep -E "ChmailMailAlias|ChmailMailForwardingAddress"  | sed 's/ChmailMailAlias:/\n\nGroup Name:/g' | sed 's/ChmailMailForwardingAddress:/Members:/g' | tee $path/report_result/allGroup
	echo -e "\nAllGroup: see $path/report_result/allGroup file,press return key to continue!"
	read
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	echo -n "Enter groupName : "
	read groupid1
	# rm -f $path/report_result/specificGroup &> /dev/null
	if [ "x$groupid1" = "x" ] ; then
		read -p "empty group mailAddress! , press return key to continue!"
	elif [[ $groupid1 =~ $regex ]] ; then
		/opt/Chmail/bin/zmprov gdl $groupid1 &> /dev/null
		distcheck=`echo $?`
		if [ "$distcheck" -ne "0" ]
		then
			read -p "No such $groupid1 group exist! press return key to continue ..."
		else
			rm -f $path/report_result/specificGroup &> /dev/null
			/opt/Chmail/bin/zmprov gdl $groupid1 | grep -E "ChmailMailAlias|ChmailMailForwardingAddress" | sed 's/ChmailMailAlias:/\n\nGroup Name:/g' | sed 's/ChmailMailForwardingAddress:/Members:/g'| tee $path/report_result/specificGroup
			echo -e "\nSpecificGroup: see $path/report_result/specificGroup file,press return key to continue!"
			read
		fi	
	else
		read -p "invalid groupName Address: $groupid1 , press return key to continue!"
	fi


elif [[ $choice =~ $numregex && $choice -eq "3" ]] ; then
	echo -n "Enter username <username@domain.com>: "
	read userid1
	rm -f $path/report_result/groupMember &> /dev/null
	if [ "x$userid1" = "x" ] ; then
		read -p "empty user mailAddress! , press return key to continue!"
	elif [[ $userid1 =~ $regex ]] ; then
		/opt/Chmail/bin/zmprov ga $userid1 &> /dev/null
		usercheck=`echo $?`
		if [ "$usercheck" -ne "0" ]
			then
			read -p "No such $userid1 account exist! press return key to continue ..."
		else
			rm -f $path/report_result/groupMember &> /dev/null
			echo $userid1 user is member of: `/opt/Chmail/bin/zmprov  sa -v ChmailMailForwardingAddress=$userid1| tac | grep "ChmailMailAlias:" | sed 's/ChmailMailAlias://g'` | tee $path/report_result/groupMember
			echo -e "\nSpecificMember: see $path/report_result/groupMember file,press return key to continue!"
			read
		fi	
	else	
		read -p "invalid user mailAddress: $userid1 , press return key to continue!"
	fi	

elif [[ $choice =~ $numregex && $choice -eq "4" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 3
	getGroupStatus
fi
getGroupStatus
}



createuser(){
clear
echo -e "file format: username@domain.com,<password>"
echo  "1)Create account base on username from:" $FFILE
echo  "2)Create account base on username & password from:" $FFILE
echo  "3)Create account base on username & password & first & lastname & personalcode from:" $FFILE
echo '4)Main menu'
echo
echo -n 'Enter your selection: '
read choice
if [ "x$choice" = "x" ]
then
	echo "Please select one of numbers!!"
	sleep 2
elif [[ $choice =~ $numregex && $choice -eq "1" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | grep -v '^$' | sed 's/\r$//' > $FILE	
	fi
	rm -f /opt/Chmail/log/create &> /dev/null	
	echo -n "enter Default password for all users: "
	read pass
	before=`/opt/Chmail/bin/zmprov -l gaa | wc -l` &> /dev/null
	awk -v userpass="${pass}" -F "," '{print "ca " $1 " "  userpass }' $FILE > /opt/Chmail/log/create
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/create
	rm -f /opt/Chmail/log/create &> /dev/null
	after=`/opt/Chmail/bin/zmprov -l gaa | wc -l` &> /dev/null
	addedusers=`expr $after - $before`
	read -p "added $addedusers users into Chmail, press return key to continue!"
	#sleep 6
elif [[ $choice =~ $numregex && $choice -eq "2" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | grep -v '^$' > $FILE	
		echo >> $FILE	
	fi
	rm -f /opt/Chmail/log/create &> /dev/null
	before=`/opt/Chmail/bin/zmprov -l gaa | wc -l` &> /dev/null
	awk -F "," '{print "ca " $1 " "  $2}' $FILE > /opt/Chmail/log/create
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/create
	rm -f /opt/Chmail/log/create &> /dev/null
	after=`/opt/Chmail/bin/zmprov -l gaa | wc -l` &> /dev/null
	addedusers=`expr $after - $before`
	read -p "added $addedusers users into Chmail, press return key to continue!"
	#sleep 6
elif [[ $choice =~ $numregex && $choice -eq "3" ]] ; then
	if [ ! -s $FFILE ] || [ "x$FFILE" = "x" ]
		then		
		echo "$FFILE: No such file"
		echo "usage: ./chaccountprov <filename>"
		sleep 2
		exit 1
	elif [ -s $FFILE ]
		then
		cat $FFILE | sed 's/\r$//'  | sed 's/^\xEF\xBB\xBF//' | grep -v '^$' > $FILE	
		#echo >> $FILE	
	fi
	rm -f /opt/Chmail/log/create &> /dev/null	
	before=`/opt/Chmail/bin/zmprov -l gaa | wc -l` &> /dev/null
	awk -F "," -v sq="'" '{print "ca " $1 " "  $2 " givenName " 'sq'$3'sq' " sn " 'sq'$4'sq' " ChmailPersonalCode "  $5}' $FILE > /opt/Chmail/log/create
	/opt/Chmail/bin/zmprov < /opt/Chmail/log/create
	rm -f /opt/Chmail/log/create &> /dev/null
	after=`/opt/Chmail/bin/zmprov -l gaa | wc -l` &> /dev/null
	addedusers=`expr $after - $before`
	read -p "added $addedusers users into Chmail, press return key to continue!"
	#sleep 2
elif [[ $choice =~ $numregex && $choice -eq "4" ]] ; then
	menu
else
	echo "invalid selection!"
	sleep 2
	createuser
fi
createuser
}

menu(){
clear
echo "1)All users"
echo "2)National code"
echo "3)Identification code"
echo "4)Personal code"
echo "5)Mobile number"
echo "6)Account status"
echo "7)firstName"
echo "8)lastName"
echo "9)firstName & lastName"
echo "10)Personal type"
echo "11)Education center"
echo "12)Education field"
echo "13)City"
echo "14)Quota usage"
echo "15)Create & login time"
echo "16)Group Status"
echo "17)Create account"
echo "18)Exit"
echo
echo -n 'Enter your Selection: '
read type
if [ "x$type" = "x" ]
then
	echo "Empty number , Please select one of numbers!!"
	sleep 2
	exit 1
elif [[ $type =~ $numregex && $type -eq "1" ]] ; then
	getAalUser
elif [[ $type =~ $numregex && $type -eq "2" ]] ; then
	getNtCode
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "3" ]] ; then
	getIDcode
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "4" ]] ; then
	getPcode
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "5" ]] ; then
	getMobile	
	rm -f $FILE		
elif [[ $type =~ $numregex && $type -eq "6" ]] ; then
	getStatus
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "7" ]] ; then
	getFirst
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "8" ]] ; then
	getLast
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "9" ]] ; then
	getFirstLast
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "10" ]] ; then
	getPtype
	rm -f $FILE	
elif [[ $type =~ $numregex && $type -eq "11" ]] ; then
	getEdCenter
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "12" ]] ; then
	getEdfield
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "13" ]] ; then
	getLocal
	rm -f $FILE	
elif [[ $type =~ $numregex && $type -eq "14" ]] ; then
	getQuota
	rm -f $FILE	
elif [[ $type =~ $numregex && $type -eq "15" ]] ; then
	getTime
	rm -f $FILE	
elif [[ $type =~ $numregex && $type -eq "16" ]] ; then
	getGroupStatus
	rm -f $FILE		
elif [[ $type =~ $numregex && $type -eq "17" ]] ; then
	createuser
	rm -f $FILE
elif [[ $type =~ $numregex && $type -eq "18" ]] ; then
	rm -f $FILE
	rm /opt/Chmail/log/report.pid
	exit 0	
elif [[ $type =~ $numregex ]] ; then
	echo "invalid Selection! : $type , press return key to continue! "
	read
	menu
else
	echo "$type: is not integer,Please select one of available numbers!! , press return key to continue!"
	read
	menu
fi
}
menu
