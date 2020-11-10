#! /bin/bash

 /opt/Chmail/bin/ldapsearch -x -w $(su - Chmail -c 'zmlocalconfig -s ldap_root_password '  | awk '{print $3}') -D "$(su - Chmail -c 'zmlocalconfig -s Chmail_ldap_userdn'  | awk '{print $3}')" -H $(su - Chmail -c 'zmlocalconfig -s ldap_url'  | awk '{print $3}') -b '' '(mobile=*)'  ChmailMailDeliveryAddress mobile|grep -Ev "#|search|result|dn:" > /opt/Chmail/log/list.mobile


grep -Ev "^$" /opt/Chmail/log/list.mobile |awk 'NR%2{printf "%s ",$0;next;}1'|awk '{print $2","$4}' > list-mobile.csv

