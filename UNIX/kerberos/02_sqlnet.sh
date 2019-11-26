#!/bin/bash
#
source 00_env.sh
#
#  add kerberos configuration lines to sqlnet.ora
#  *** does NOT check to see if the lines are already added ***
#
# remove the appropriate kerberos lines from sqlnet.ora
ed ${ORACLE_HOME}/network/admin/sqlnet.ora <<! >/dev/null 2>&1
/SQLNET.KERBEROS5_KEYTAB
d
/SQLNET.KERBEROS5_CONF_MIT
d
/SQLNET.KERBEROS5_CONF
d
/SQLNET.AUTHENTICATION_KERBEROS5_SERVICE
d
/SQLNET.AUTHENTICATION_SERVICES
d
wq
!
cat <<! >>${ORACLE_HOME}/network/admin/sqlnet.ora
SQLNET.KERBEROS5_KEYTAB=${KEYTAB_DIR}/${KEYTAB_FILE}
SQLNET.KERBEROS5_CONF=/etc/krb5.conf
SQLNET.KERBEROS5_CONF_MIT=TRUE
SQLNET.AUTHENTICATION_KERBEROS5_SERVICE=${ORACLE_SERVICE}
SQLNET.AUTHENTICATION_SERVICES=(BEQ,TCPS,KERBEROS5,KERBEROS5PRE)
!
cat ${ORACLE_HOME}/network/admin/sqlnet.ora
