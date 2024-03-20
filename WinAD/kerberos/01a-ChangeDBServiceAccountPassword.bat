@echo off
rem
rem Generate a PowerShell cmdlet to change the password of a service account in AD - then run the cmdlet
rem - command MUST be run as administrator
rem
rem there is NO error checking, if it fails, then fix the errors manually and re-run
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
echo %AD_CONTAINER%
echo %AD_DOMAIN_DN%
rem
rem generate the change user password cmdlet
rem
echo # >01a-changeuserpass_%ENV%.ps1
echo # Change the password of a service account >>01a-changeuserpass_%ENV%.ps1
echo Set-ADAccountPassword -Identity ^"%REMOTE_NODE%^" -Reset -NewPassword  (ConvertTo-SecureString -AsPlainText ^"%SERVICE_ACCT_PASSWORD%^" -Force) >>01a-changeuserpass_%ENV%.ps1
echo # >>01a-changeuserpass_%ENV%.ps1
rem
rem - pause the powershell to capture the output
echo cmd /c pause >>01a-changeuserpass_%ENV%.ps1
rem
rem - execute PowerShell as administrator
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "".\01a-changeuserpass_%ENV%.ps1""' -Verb RunAs}"
rem
rem regenerate the keytab file
call 02-ktp %ENV%
rem
rem regenerate the UNIX DB environment
call 03-remote-envUNIX-DB %ENV%
