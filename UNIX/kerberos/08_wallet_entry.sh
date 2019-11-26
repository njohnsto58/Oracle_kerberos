#!/bin/bash
#
source 00_env.sh
source 00_cmu_env.sh
#
# create the wallet in the appropriate location
#  if the wallet isn't there - then create it as an auto_open
#  not sure how to convert a wallet that's been created (for non TDE) to an auto_open
#
echo Create an entry in wallet with the user name of the Oracle service directory user account
mkstore -wrl ${WALLET_LOCATION} -createEntry ORACLE.SECURITY.USERNAME ${ORACLE_NODE} <<!
$WALLET_PASSWORD
!
#
echo Create an entry in wallet with the DN of the Oracle service directory user account
mkstore -wrl ${WALLET_LOCATION} -createEntry ORACLE.SECURITY.DN "cn=${ORACLE_NODE,,}.${ORACLE_DOMAIN,,},${AD_CONTAINER},${AD_DOMAIN_DN}" <<!
$WALLET_PASSWORD
!
#
echo Create an entry in wallet with the user password credential of the Oracle service directory user account
mkstore -wrl ${WALLET_LOCATION} -createEntry ORACLE.SECURITY.PASSWORD ${AD_SERVICE_ACCT_PASSWORD} <<!
$WALLET_PASSWORD
!
#
echo Add the certificate to the wallet
orapki wallet add -wallet ${WALLET_LOCATION} -cert ${AD_CERT} -trusted_cert -pwd ${WALLET_PASSWORD}
#
# display credentials
orapki wallet display -wallet ${WALLET_LOCATION} -pwd ${WALLET_PASSWORD}
