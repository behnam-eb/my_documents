#! /bin/bash
DATABASES_TO_EXCLUDE="mysql"
EXCLUSION_LIST="'information_schema','mysql','chadd'"
for DB in `echo "${DATABASES_TO_EXCLUDE}"`
do
    EXCLUSION_LIST="${EXCLUSION_LIST},'${DB}'"
done
SQLSTMT="\"SELECT schema_name FROM information_schema.schemata"
SQLSTMT="${SQLSTMT} WHERE schema_name NOT IN (${EXCLUSION_LIST});"

MYSQLDUMP_DATABASES="--databases"
for DB in `su - Chmail -c "mysql -ANe $SQLSTMT\""`
do
    MYSQLDUMP_DATABASES="${MYSQLDUMP_DATABASES} ${DB}"
done
MYSQLDUMP_OPTIONS=" --user=root --password=$(su - Chmail -c 'zmlocalconfig -s mysql_root_password' | awk '{print $3}') --socket=/opt/Chmail/db/mysql.sock --single-transaction  --flush-logs"
/opt/Chmail/mysql/bin/mysqldump ${MYSQLDUMP_OPTIONS}   ${MYSQLDUMP_DATABASES} > all.sql
