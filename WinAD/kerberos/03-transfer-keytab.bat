@echo off
rem
rem transfer the generated keytab to the remote node
rem  assume a certificate between AD node and remote database has been created - otherwise amend script and enter password when prompted
rem
if "%~1" == "" (
  echo need environment
  exit /b 1
)
call AD.bat
set ENV=%1%
call %ENV%
rem
rem - transfer file to database node (as oracle user)
rem - assume a certificate has been created to enable transfer - otherwise amend to add password
@echo on
pscp -i %SCP_KEY% %KEYTAB_FILE% oracle@%REMOTE_NODE%.%REMOTE_DOMAIN%:%KEYTAB_DIR%/%KEYTAB_FILE%