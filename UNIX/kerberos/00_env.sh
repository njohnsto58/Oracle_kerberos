#!/bin/bash 
# if file has been transferred from Windows remove carriage returns 
if [ -f 00_env_DOS.sh  ]; then 
  tr -d '\r' <00_env_DOS.sh >00_env.sh 
  rm 00_env_DOS.sh 
  source 00_env.sh 
else 
  ORACLE_NODE=hostname 
fi 
