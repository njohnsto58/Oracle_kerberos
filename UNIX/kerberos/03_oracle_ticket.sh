#!/bin/bash
#
source 00_env.sh
#
# generate TGT ticket for Oracle DB service account
#
# generate a script to create a ticket for oracle
set -e
cat <<! >oracle_ticket.sh
okinit -k -t ${KEYTAB_DIR}/${KEYTAB_FILE} ${ORACLE_SERVICE}/${ORACLE_NODE}.${ORACLE_DOMAIN}@${AD_DOMAIN} 2>okinit$$.err
cat okinit$$.err
ERR=\$(awk 'FNR==2{print \$0}' <okinit$$.err)
rm okinit$$.err
if [ -z "\$ERR" ]; then
  oklist
else
  exit 1
fi
!
chmod +x oracle_ticket.sh
./oracle_ticket.sh
# check to see if kvno exists
export KVNO=$(which kvno 2>/dev/null)
if [ -z "$KVNO" ]; then
  #
  #  generate a script to transfer file to node with kerberos utilities
  XFER_SCRIPT="oracle_ticket_${ORACLE_NODE}.sh"
  echo '#!/bin/bash' >${XFER_SCRIPT}
  echo '#' >>${XFER_SCRIPT}
  echo '# Obtain the Key Version Number' >>${XFER_SCRIPT}
  echo "scp ${USER}@${ORACLE_NODE}.${ORACLE_DOMAIN}:${KEYTAB_DIR}/${KEYTAB_FILE} ." >>${XFER_SCRIPT}
  echo "kinit -k -t ${KEYTAB_FILE} ${ORACLE_SERVICE}/${ORACLE_NODE}.${ORACLE_DOMAIN}@${AD_DOMAIN}" >>${XFER_SCRIPT}
  echo klist -k -t ${KEYTAB_FILE} >>${XFER_SCRIPT}
  echo kvno ${ORACLE_SERVICE}/${ORACLE_NODE}.${ORACLE_DOMAIN}@${AD_DOMAIN} >>${XFER_SCRIPT}
  chmod +x ${XFER_SCRIPT}
  echo
  echo "Transfer the file $(pwd)/${XFER_SCRIPT} to the node with Kerberos Utilities to execute"
  echo
else
  # Kerberos utilities exist on this node - obtain the Key Version Number
  # verify handshake and kvno= <same number generated on windows box>
  kvno ${ORACLE_SERVICE}/${ORACLE_NODE}.${ORACLE_DOMAIN}@${AD_DOMAIN}
fi
