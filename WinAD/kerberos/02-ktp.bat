@echo off
rem
rem generate a keytab file
rem
rem AD Username = ORACLE_SERVICE/REMOTE_NODE.REMOTE_DOMAIN
rem e.g. oracle/oem-host.publicsn1.dbsec.oraclevcn.com
rem
rem AD user logon name = REMOTE_NODE
rem e.g. oem-host
rem
if "%~1" == "" (
  echo need environment
  exit /b 1
)
call AD.bat
set ENV=%1%
call %ENV%
rem
rem check if being run as administrator
rem
rem whoami /groups |findstr /b /c:"Mandatory Label\High Mandatory Level" | findstr /c:"Enabled group" >nul: && set IS_ELEVATED=1
set IS_ELEVATED=0
whoami /groups |findstr /b /c:"Mandatory Label\High Mandatory Level" >nul: && set IS_ELEVATED=1
if %IS_ELEVATED%==0 (
 ECHO You must run the command as administrator
 exit /b 1
)
rem
rem grab the private shared secret key for the service - doesn't look like we need the key version = %KVO%
@echo on
rem ktpass -princ %ORACLE_SERVICE%/%REMOTE_NODE%.%REMOTE_DOMAIN%@%AD_DOMAIN% -mapuser %REMOTE_NODE%.%REMOTE_DOMAIN% -crypto RC4-HMAC-NT -kvno %KVO% -pass %SERVICE_ACCT_PASSWORD% -out %KEYTAB_FILE% -ptype KRB5_NT_PRINCIPAL
ktpass -princ %ORACLE_SERVICE%/%REMOTE_NODE%.%REMOTE_DOMAIN%@%AD_DOMAIN% -mapuser %REMOTE_NODE%.%REMOTE_DOMAIN% -crypto RC4-HMAC-NT -pass %SERVICE_ACCT_PASSWORD% -out %KEYTAB_FILE% -ptype KRB5_NT_PRINCIPAL
@echo off
rem
rem - check SPN
setspn -L %REMOTE_NODE%
rem set /p TRANSFER= "Do you want to transfer to database node now (y/n)?"
rem if "%TRANSFER%" == "y" (
rem   call 03-transfer-keytab %ENV%
rem ) else (
rem   echo
rem   echo Transfer keytab database node: 03-transfer-keytab %ENV%
rem )
rem
move %KEYTAB_FILE% %REMOTE_NODE%-host