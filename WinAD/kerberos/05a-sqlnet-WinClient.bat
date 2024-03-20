@echo off
rem
rem generate changes to the file sqlnet.ora
rem
call AD.bat
set REMOTE_SQLNET_FILE=sqlnet_krb.ora
echo # >%REMOTE_SQLNET_FILE%
echo # Add these lines to the sqlnet.ora >>%REMOTE_SQLNET_FILE%
echo # Asume the environment variable %%TNS_ADMIN%%  >>%REMOTE_SQLNET_FILE%
echo SQLNET.KERBEROS5_CONF=%%TNS_ADMIN%%\krb5.ini >>%REMOTE_SQLNET_FILE%
echo SQLNET.KERBEROS5_CONF_MIT=TRUE  >>%REMOTE_SQLNET_FILE%
echo SQLNET.KERBEROS5_CLOCKSKEW=6000 >>%REMOTE_SQLNET_FILE%
echo #SQLNET.AUTHENTICATION_KERBEROS5_SERVICE=%ORACLE_SERVICE%  >>%REMOTE_SQLNET_FILE%
echo SQLNET.AUTHENTICATION_SERVICES=(KERBEROS5,KERBEROS5PRE)  >>%REMOTE_SQLNET_FILE%
echo #SQLNET.KERBEROS5_CC_NAME=MSLSA:  >>%REMOTE_SQLNET_FILE%
echo SQLNET.KERBEROS5_CC_NAME=OSMSFT://  >>%REMOTE_SQLNET_FILE%
move /Y %REMOTE_SQLNET_FILE% WinClient