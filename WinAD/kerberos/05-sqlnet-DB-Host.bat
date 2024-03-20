@echo off
rem
rem generate changes to the file sqlnet.ora on the UNIX DB Host
rem
rem
if "%~1" == "" (
  echo need environment
  exit /b 1
)
call AD.bat
set ENV=%1%
call %ENV%
set REMOTE_SQLNET_FILE=sqlnet_%REMOTE_NODE%.ora
echo # >%REMOTE_SQLNET_FILE%
echo # Add these lines to the sqlnet.ora >>%REMOTE_SQLNET_FILE%
echo # >>%REMOTE_SQLNET_FILE%
echo # >>%REMOTE_SQLNET_FILE%
echo SQLNET.KERBEROS5_KEYTAB=%KEYTAB_DIR%/%KEYTAB_FILE% >>%REMOTE_SQLNET_FILE%
echo SQLNET.KERBEROS5_CONF=%KRB5_CONFIG%/krb5.conf >>%REMOTE_SQLNET_FILE%
echo SQLNET.KERBEROS5_CONF_MIT=TRUE  >>%REMOTE_SQLNET_FILE%
echo SQLNET.KERBEROS5_CLOCKSKEW=6000 >>%REMOTE_SQLNET_FILE%
echo SQLNET.AUTHENTICATION_KERBEROS5_SERVICE=%ORACLE_SERVICE%  >>%REMOTE_SQLNET_FILE%
echo SQLNET.AUTHENTICATION_SERVICES=(BEQ,TCPS,KERBEROS5,KERBEROS5PRE)  >>%REMOTE_SQLNET_FILE%
rem
move /Y %REMOTE_SQLNET_FILE% %REMOTE_NODE%-Host