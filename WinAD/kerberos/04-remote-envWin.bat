@echo off
rem
rem create the remote Win Client environment file
rem
if "%~1" == "" (
  echo need environment
  exit /b 1
)
call AD.bat
set ENV=%1%
call %ENV%
set REMOTE_ENV_FILE=00_env_WINClient.bat
echo   set ORACLE_NODE=%REMOTE_NODE% >>%REMOTE_ENV_FILE%
echo   set ORACLE_DOMAIN=%REMOTE_DOMAIN% >>%REMOTE_ENV_FILE%
echo   ORACLE_HOME=%ORACLE_HOME% >>%REMOTE_ENV_FILE%
echo   ORACLE_SERVICE=%ORACLE_SERVICE% >>%REMOTE_ENV_FILE%
echo   ORACLE_SYSUSER=%ORACLE_SYSUSER% >>%REMOTE_ENV_FILE%
echo   ORACLE_SYSPASS=%ORACLE_SYSPASS% >>%REMOTE_ENV_FILE%
echo   ORACLE_CONN=//%REMOTE_NODE%/%ORACLE_DB_SERVICE% >>%REMOTE_ENV_FILE%
echo   KEYTAB_FILE=%KEYTAB_FILE% >>%REMOTE_ENV_FILE%
echo   KEYTAB_DIR=%KEYTAB_DIR% >>%REMOTE_ENV_FILE%
echo   # >>%REMOTE_ENV_FILE%
echo   AD_NODE=%AD_NODE% >>%REMOTE_ENV_FILE%
echo   AD_DOMAIN="%AD_DOMAIN%" >>%REMOTE_ENV_FILE%
echo   AD_DOMAIN_DN="%AD_DOMAIN_DN%" >>%REMOTE_ENV_FILE%
echo   AD_CONTAINER="%AD_CONTAINER%" >>%REMOTE_ENV_FILE%
echo   AD_SERVICE_ACCT_PASSWORD=%SERVICE_ACCT_PASSWORD% >>%REMOTE_ENV_FILE%
echo   AD_CERT="root.crt" >>%REMOTE_ENV_FILE%
echo   DB_DOMAIN_REALMS=(%DB_DOMAIN_REALMS%) >>%REMOTE_ENV_FILE%
echo fi >>%REMOTE_ENV_FILE%
set /p TRANSFER= "Do you want to transfer to database node now (y/n)?"
if "%TRANSFER%" == "y" (
  call 05-transfer-env %ENV%
) else (
  echo Transfer database environment to database node: 05-transfer-env %ENV%
)