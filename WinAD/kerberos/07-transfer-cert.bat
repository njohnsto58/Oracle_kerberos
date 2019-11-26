@echo off
rem
rem transfer the remote UNIX environment file
rem  assume a certificate between AD node and remote database has been created - otherwise amend script and enter password when prompted
rem
if "%~1" == "" (
  echo need environment
  exit /b 1
)
call AD.bat
set ENV=%1%
call %ENV%
set REMOTE_ENV_FILE=00_env_%REMOTE_NODE%.sh
pscp -i %SCP_KEY% %AD_CERT_DIR%\root.crt oracle@%REMOTE_NODE%.%REMOTE_DOMAIN%:%REMOTE_DIR%