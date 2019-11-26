#!/bin/bash
#
source 00_env.sh
source 00_cmu_env.sh
#
# create the wallet in the appropriate location
#  if the wallet isn't there - then create it as an auto_open
#  not sure how to convert a wallet that's been created (for non TDE) to an auto_open
#
# would like to read the WALLET_LOCATION from the sqlnet.ora - but don't know how - so require it as an environment variable
#
# detect if the wallet directory is there ...
if [ ! -d "${WALLET_LOCATION}" ]; then
  # directory doesn't exist - attempt to create it
  echo Creating directory ${WALLET_LOCATION}
  mkdir -p ${WALLET_LOCATION}
  if [ ! -d "${WALLET_LOCATION}" ]; then
    echo Unable to create wallet location ${WALLET_LOCATION}
    exit 1
  fi
fi
#
# directory exists - create a wallet if it's not there - ASSUME it's an auto_login
if [ ! -f "${WALLET_LOCATION}"/ewallet.p12 ]; then
  #
  echo Creating auto_login wallet in ${WALLET_LOCATION}
  orapki wallet create -wallet ${WALLET_LOCATION} -auto_login -pwd ${WALLET_PASSWORD}
fi
read -p "Do you want to install the credentials (y/n)?" YN
if [ "$YN" == "y" ]; then
  ./08_wallet_entry.sh
fi
