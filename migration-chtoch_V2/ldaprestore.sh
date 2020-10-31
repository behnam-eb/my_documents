#!/bin/bash
IP=`ifconfig |grep "inet addr"|grep -v "127.0.0.1"|awk '{print $2}'|sed 's/addr://'`

/opt/Chmail/openldap/bin/ldapadd -c -x -w $(su - Chmail -c 'zmlocalconfig -s ldap_root_password '  | awk '{print $3}') -D "$(su - Chmail -c 'zmlocalconfig -s Chmail_ldap_userdn'  | awk '{print $3}')" -H ldap://"$IP" -f user.ldif


