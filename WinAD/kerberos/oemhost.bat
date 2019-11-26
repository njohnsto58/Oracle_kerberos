set REMOTE_NODE=oem-host
set REMOTE_DOMAIN=publicsn1.dbsec.oraclevcn.com
set REMOTE_DIR=dbsec-scripts/kerberos-setup
set ORACLE_SERVICE=oracle
set ORACLE_DB_SERVICE=oms.publicsn1.dbsec.oraclevcn.com
set ORACLE_HOME=/u01/app/oracle/product/12.2.0/dbhome_1
set ORACLE_SYSUSER=system
set ORACLE_SYSPASS=OR4cl3__123
rem
set KEYTAB_FILE=db-%ORACLE_SERVICE%-%REMOTE_NODE%.keytab
set KEYTAB_DIR=%ORACLE_HOME%/network/admin
set KVO=3
set SERVICE_ACCT_PASSWORD=OR4cl3__123
