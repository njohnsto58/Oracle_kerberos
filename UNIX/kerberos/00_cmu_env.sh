#!/bin/bash 
# if file has been transferred from Windows remove carriage returns 
if [ -f 00_env_DOS.sh  ]; then 
  tr -d '\r' <00_env_DOS.sh >00_env.sh 
  rm 00_env_DOS.sh 
  source 00_env.sh 
else 
  #DSI_LOCATION=/u01/app/oracle/product/18.0.0.0/dbhome_1/admin/DBAAS4_lhr1h4/wallet
  #WALLET_LOCATION=/u01/app/oracle/product/18.0.0.0/dbhome_1/admin/DBAAS4_lhr1h4/wallet
  DSI_LOCATION=/u01/app/oracle/admin/${ORACLE_UNQNAME}/wallet
  WALLET_LOCATION=/u01/app/oracle/admin/${ORACLE_UNQNAME}/wallet
  WALLET_PASSWORD=OR4cl3__123
fi 
