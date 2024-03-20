set REMOTE_NODE=dbaas1
set REMOTE_DOMAIN=subnet1.njvcn1.oraclevcn.com
set REMOTE_DIR=scripts/kerberos-setup
set ORACLE_DB_SERVICE=pdb3.subnet1.njvcn1.oraclevcn.com
set ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
set TNS_ADMIN=%ORACLE_HOME%/network/admin
set ORACLE_SYSUSER=system
set ORACLE_SYSPASS=OR4cl3__123
rem
set KEYTAB_FILE=db-%ORACLE_SERVICE%-%REMOTE_NODE%.keytab
set KEYTAB_DIR=%ORACLE_HOME%/network/admin
set KRB5_CONFIG=/etc
set SERVICE_ACCT_PASSWORD=OR4cl3__123--
rem set ORACLE_SERVICE=oracle
set ORACLE_SERVICE=DBAAS1
