@echo off
rem
rem create a container in Active Directory
rem
call AD.bat
if "%~1" == "" (
  echo need groupname
  exit /b 1
)

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
echo %AD_GROUPS%
echo %AD_DOMAIN_DN%
dsadd group %AD_GROUPS%,%AD_DOMAIN_DN%