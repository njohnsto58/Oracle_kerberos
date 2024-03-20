@echo off
rem
rem transfer the generated files to the remote database node
rem  assume a key has already beed generated between AD node and remote database node
rem - otherwise amend script and enter password when prompted
rem
if "%~1" == "" (
  echo need environment
  exit /b 1
)
call AD.bat
set ENV=%1%
call %ENV%
rem
rem - transfer all the files in %ENV%-Host to %ENV% (as oracle user)
rem - assume a key has been created to enable transfer - otherwise amend to add password
echo Transferring files in %ENV%-Host to %REMOTE_NODE%.%REMOTE_DOMAIN%
@echo on
pscp -i %SCP_KEY% %ENV%-Host/* oracle@%REMOTE_NODE%.%REMOTE_DOMAIN%:%REMOTE_DIR%
@echo off
echo Transferring root certificate to %REMOTE_NODE%.%REMOTE_DOMAIN%
@echo on
pscp -i %SCP_KEY%  %AD_CERT_DIR%/root.crt oracle@%REMOTE_NODE%.%REMOTE_DOMAIN%:%REMOTE_DIR%
