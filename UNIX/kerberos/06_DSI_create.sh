#!/bin/bash
# 
source 00_env.sh
source 00_cmu_env.sh
#
# create the dsi.ora file ...
if [ ! -d "${DSI_LOCATION}" ]; then
  # directory doesn't exist - attempt to create it
  echo Creating directory ${DSI_LOCATION}
  mkdir -p ${DSI_LOCATION}
  if [ ! -d "${DSI_LOCATION}" ]; then
    echo Unable to create DSI location ${DSI_LOCATION}
    exit 1
  fi
fi

cat <<! >${DSI_LOCATION}/dsi.ora
DSI_DIRECTORY_SERVERS = (${AD_NODE,,}.${AD_DOMAIN,,}:389:636)
DSI_DIRECTORY_SERVER_TYPE = AD
!
cat ${DSI_LOCATION}/dsi.ora
