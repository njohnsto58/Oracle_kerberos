@echo off
rem
rem Generate a PowerShell cmdlet to create a service account in AD - then run the cmdlet
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
rem generate the Add user cmdlet
rem
echo # >01-newuser_%ENV%.ps1
echo # Create a service account >>01-newuser_%ENV%.ps1
echo New-ADUser -Name ^"%REMOTE_NODE%.%REMOTE_DOMAIN%^" -GivenName ^"%REMOTE_NODE%^" -SamAccountName ^"%REMOTE_NODE%^" -UserPrincipalName ^"%ORACLE_SERVICE%/%REMOTE_NODE%.%REMOTE_DOMAIN%@%AD_DOMAIN%^" -Path ^"%AD_CONTAINER%,%AD_DOMAIN_DN%^" -ServicePrincipalNames ^"%ORACLE_SERVICE%/%REMOTE_NODE%.%REMOTE_DOMAIN%^" -DisplayName ^"%REMOTE_NODE%.%REMOTE_DOMAIN%^" -AccountPassword (ConvertTo-SecureString -AsPlainText ^"%SERVICE_ACCT_PASSWORD%^" -Force) -passThru -PasswordNeverExpires $True -Enabled $True  >>01-newuser_%ENV%.ps1
echo # >>01-newuser_%ENV%.ps1
echo # modify the user - does not require kerberos pre-authentication >>01-newuser_%ENV%.ps1
rem
echo Set-ADAccountControl -Identity ^"CN=%REMOTE_NODE%.%REMOTE_DOMAIN%,%AD_CONTAINER%,%AD_DOMAIN_DN%^" -DoesNotRequirePreAuth $True >>01-newuser_%ENV%.ps1
rem
rem - pause the powershell to capture the output
echo cmd /c pause >>01-newuser_%ENV%.ps1
rem
rem - execute PowerShell as administrator
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File "".\01-newuser_%ENV%.ps1""' -Verb RunAs}"
rem
rem create the directory for UNIX transfer
mkdir %REMOTE_NODE%-Host
