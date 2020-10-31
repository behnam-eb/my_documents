#!/bin/bash
for dom in `/opt/Chmail/bin/zmprov -l gad | awk -F "." '{print $NF}'|sort | uniq`
do
/opt/Chmail/bin/ldapsearch -x -w $(su - Chmail -c 'zmlocalconfig -s ldap_root_password '  | awk '{print $3}') -D "$(su - Chmail -c 'zmlocalconfig -s Chmail_ldap_userdn'  | awk '{print $3}')" -H $(su - Chmail -c 'zmlocalconfig -s ldap_url'  | awk '{print $3}') -b "dc="$dom"" -LLL >> user.ldif
done

/opt/Chmail/bin/ldapsearch -x -w $(su - Chmail -c 'zmlocalconfig -s ldap_root_password '  | awk '{print $3}') -D "$(su - Chmail -c 'zmlocalconfig -s Chmail_ldap_userdn'  | awk '{print $3}')" -H $(su - Chmail -c 'zmlocalconfig -s ldap_url'  | awk '{print $3}') -b '' '(cn=globalgrant)' -LLL > grant.ldif
/opt/Chmail/bin/ldapsearch -x -w $(su - Chmail -c 'zmlocalconfig -s ldap_root_password '  | awk '{print $3}') -D "$(su - Chmail -c 'zmlocalconfig -s Chmail_ldap_userdn'  | awk '{print $3}')" -H $(su - Chmail -c 'zmlocalconfig -s ldap_url'  | awk '{print $3}') -b '' '(cn=config)' -LLL > globalconfig.ldif
/opt/Chmail/bin/ldapsearch -x -w $(su - Chmail -c 'zmlocalconfig -s ldap_root_password '  | awk '{print $3}') -D "$(su - Chmail -c 'zmlocalconfig -s Chmail_ldap_userdn'  | awk '{print $3}')" -H $(su - Chmail -c 'zmlocalconfig -s ldap_url'  | awk '{print $3}') -b 'cn=cos,cn=Chmail'  -LLL > AllCos.ldif
/opt/Chmail/bin/ldapsearch -x -w $(su - Chmail -c 'zmlocalconfig -s ldap_root_password '  | awk '{print $3}') -D "$(su - Chmail -c 'zmlocalconfig -s Chmail_ldap_userdn'  | awk '{print $3}')" -H $(su - Chmail -c 'zmlocalconfig -s ldap_url'  | awk '{print $3}') -b 'cn=servers,cn=Chmail'  -LLL > Allservers.ldif
/opt/Chmail/bin/ldapsearch -x -w $(su - Chmail -c 'zmlocalconfig -s ldap_root_password '  | awk '{print $3}') -D "$(su - Chmail -c 'zmlocalconfig -s Chmail_ldap_userdn'  | awk '{print $3}')" -H $(su - Chmail -c 'zmlocalconfig -s ldap_url'  | awk '{print $3}') -b ''  -LLL > AllData.ldif