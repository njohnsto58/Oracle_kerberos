@echo off
rem
rem create the remote UNIX Database environment file
rem
if "%~1" == "" (
  echo need environment
  exit /b 1
)
call AD.bat
set ENV=%1%
call %ENV%
set REMOTE_ENV_FILE=00_env_%REMOTE_NODE%.sh
echo #!/bin/bash >%REMOTE_ENV_FILE%
echo # if file has been transferred from Windows remove carriage returns >>%REMOTE_ENV_FILE%
echo if [ -f 00_env_DOS.sh  ]; then >>%REMOTE_ENV_FILE%
echo   tr -d ^'\r^' ^<00_env_DOS.sh ^>00_env.sh >>%REMOTE_ENV_FILE%
echo   rm 00_env_DOS.sh >>%REMOTE_ENV_FILE%
echo   source 00_env.sh >>%REMOTE_ENV_FILE%
echo else >>%REMOTE_ENV_FILE%
echo   ORACLE_NODE=%REMOTE_NODE% >>%REMOTE_ENV_FILE%
echo   ORACLE_DOMAIN=%REMOTE_DOMAIN% >>%REMOTE_ENV_FILE%
echo   ORACLE_HOME=%ORACLE_HOME% >>%REMOTE_ENV_FILE%
echo   TNS_ADMIN=%TNS_ADMIN% >>%REMOTE_ENV_FILE%
echo   ORACLE_SERVICE=%ORACLE_SERVICE% >>%REMOTE_ENV_FILE%
echo   ORACLE_SYSUSER=%ORACLE_SYSUSER% >>%REMOTE_ENV_FILE%
echo   ORACLE_SYSPASS=%ORACLE_SYSPASS% >>%REMOTE_ENV_FILE%
echo   ORACLE_CONN=//%REMOTE_NODE%/%ORACLE_DB_SERVICE% >>%REMOTE_ENV_FILE%
echo   KEYTAB_FILE=%KEYTAB_FILE% >>%REMOTE_ENV_FILE%
echo   KEYTAB_DIR=%KEYTAB_DIR% >>%REMOTE_ENV_FILE%
echo   KRB5_CONFIG=%KRB5_CONFIG% >>%REMOTE_ENV_FILE%
echo   # >>%REMOTE_ENV_FILE%
echo   AD_NODE=%AD_NODE% >>%REMOTE_ENV_FILE%
echo   AD_DOMAIN="%AD_DOMAIN%" >>%REMOTE_ENV_FILE%
echo   AD_DOMAIN_DN="%AD_DOMAIN_DN%" >>%REMOTE_ENV_FILE%
echo   AD_CONTAINER="%AD_CONTAINER%" >>%REMOTE_ENV_FILE%
echo   AD_SERVICE_ACCT_PASSWORD=%SERVICE_ACCT_PASSWORD% >>%REMOTE_ENV_FILE%
echo   AD_CERT="root.crt" >>%REMOTE_ENV_FILE%
echo   DB_DOMAIN_REALMS=(%DB_DOMAIN_REALMS%) >>%REMOTE_ENV_FILE%
echo fi >>%REMOTE_ENV_FILE%
rem set /p TRANSFER= "Do you want to transfer to database node now (y/n)?"
rem if "%TRANSFER%" == "y" (
rem   call 05-transfer-env %ENV%
rem ) else (
rem   echo Transfer database environment to database node: 05-transfer-env %ENV%
rem )
rem
move /Y %REMOTE_ENV_FILE% %REMOTE_NODE%-host\00_env_DOS.sh