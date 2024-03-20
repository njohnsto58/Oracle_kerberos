rem
rem - AD Container MUST NOT have the DOMAIN_DN (this will be added by the appropriate scripts)
rem
set AD_NODE=TSEWIN19-AD
set AD_DOMAIN=CMGSOL.CORP
set AD_DOMAIN_DN=dc=cmgsol,dc=corp
set AD_CONTAINER=ou=Service Accounts
set AD_GROUPS=ou=Groups
set DB_DOMAIN_REALMS=subnet1.njvcn1.oraclevcn.com
set SCP_KEY="C:\Users\administrator\.ssh\id_rsa.ppk"
set AD_CERT_DIR=C:\Users\administrator\Certificates
