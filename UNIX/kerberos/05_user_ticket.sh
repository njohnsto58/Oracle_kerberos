#!/bin/bash
#
source 00_env.sh
#
# generate a user ticket
#  Usage: 05_user_ticket <username>
#
if [ "$#" -lt 1 ]; then
  echo Usage $0 Username
  exit 1
fi
DB_USER=$1
#
# generate a create ticket script
cat <<! > ${DB_USER,,}_ticket.sh
okinit ${DB_USER,,}@${AD_DOMAIN^^} 2>okinit$$.err
cat okinit$$.err
ERR=\$(awk 'FNR==2{print \$0}' <okinit$$.err)
rm okinit$$.err
if [ -z "\$ERR" ]; then
  oklist
else
  exit 1
fi
!
chmod +x ${DB_USER,,}_ticket.sh
#
# execute ticket
echo Generating Kerberos Ticket...
echo "./${DB_USER,,}_ticket.sh"
./${DB_USER,,}_ticket.sh
