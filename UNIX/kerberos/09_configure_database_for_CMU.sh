#!/bin/bash
#
source 00_env.sh
source 00_cmu_env.sh
#
# configure database to look at the LDAP settings
sqlplus / as sysdba <<!
alter system set LDAP_DIRECTORY_ACCESS = 'PASSWORD' scope=spfile;
alter system set LDAP_DIRECTORY_SYSAUTH = YES scope=spfile;
!
# confirm database restart
read -p "Shutdown and start database (y/n)?" YN
if [ "$YN" == "y" ]; then
  sqlplus / as sysdba <<!
shutdown immediate
startup
show parameter ldap
!
else
  echo "Restart database for changes to take effect"
fi
