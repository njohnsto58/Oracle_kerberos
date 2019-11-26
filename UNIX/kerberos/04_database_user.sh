#!/bin/bash
#
source 00_env.sh
#
# create a database user
#  Usage: 04_database_user <username>
#
if [ "$#" -lt 1 ]; then
  echo Usage $0 Username
  exit 1
fi
DB_USER=$1
cat <<! > ${DB_USER,,}.sql
create user ${DB_USER,,} identified externally as '${DB_USER,,}@${AD_DOMAIN^^}';
grant create session to ${DB_USER,,};
exit
!
cat ${DB_USER,,}.sql
sqlplus ${ORACLE_SYSUSER}/${ORACLE_SYSPASS}@${ORACLE_CONN} @${DB_USER,,}
#
# generate a create ticket script
cat <<! > ${DB_USER,,}_ticket.sh
okinit ${DB_USER,,}@${AD_DOMAIN^^}
oklist
!
chmod +x ${DB_USER,,}_ticket.sh

