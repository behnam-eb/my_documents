#!/bin/bash
IP=`ifconfig |grep "inet addr"|grep -v "127.0.0.1"|awk '{print $2}'|sed 's/addr://'`
for dom in `/opt/Chmail/bin/zmprov -l gad | awk -F "." '{print $NF}'|sort | uniq`
do
/opt/Chmail/bin/ldapsearch -x -w $(su - Chmail -c 'zmlocalconfig -s ldap_root_password '  | awk '{print $3}') -D "$(su - Chmail -c 'zmlocalconfig -s Chmail_ldap_userdn'  | awk '{print $3}')" -H ldap://"$IP"   -b "dc="$dom"" -LLL |grep dn: | grep "dc="$dom"" | grep -v ^$ | sed 's/dn: //g' |tac>> del.ldif
done
