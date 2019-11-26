#!/bin/bash
#
source 00_env.sh
source 00_cmu_env.sh
#
# create a database user
#  Usage: 04_database_user <username> <distinguished name>
#
if [ "$#" -lt 2 ]; then
  echo Usage $0 Username Distinguished-Name
  echo e.g. $0 scott "CN=scott,OU=People,DC=winsn1,DC=dbsec,DC=oraclevcn,DC=com"
  exit 1
fi
DB_USER=$1
AD_DN=$2
cat <<! > ${DB_USER,,}.sql
create user ${DB_USER,,} identified globally as '${AD_DN}';
grant create session to ${DB_USER,,};
exit
!
cat ${DB_USER,,}.sql
sqlplus ${ORACLE_SYSUSER}/${ORACLE_SYSPASS}@${ORACLE_CONN} @${DB_USER,,}
