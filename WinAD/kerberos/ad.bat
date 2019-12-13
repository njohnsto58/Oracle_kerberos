rem
rem - AD Container MUST NOT have the DOMAIN_DN (this will be added by the appropriate scripts)
rem
set AD_NODE=win-2016
set AD_DOMAIN=WINSN1.DBSEC.ORACLEVCN.COM
set AD_DOMAIN_DN=dc=winsn1,dc=dbsec,dc=oraclevcn,dc=com
set AD_CONTAINER=ou=Service Accounts,ou=Shared Infrastructure
set DB_DOMAIN_REALMS=publicsn1.dbsec.oraclevcn.com dbsn1.dbsec.oraclevcn.com dbsn2.dbsec.oraclevcn.com
set SCP_KEY="..\.ssh\frank_id_rsa.ppk"
set AD_CERT_DIR=C:\Users\opc\Documents
