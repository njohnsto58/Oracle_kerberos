@echo off
rem
rem export the AD certificate
rem
if "%~1" == "" (
  echo need environment
  exit /b 1
)
call AD.bat
set ENV=%1%
call %ENV%
rem
rem Check if the cert directory exists - if not create it
if NOT EXIST %AD_CERT_DIR% (
  mkdir %AD_CERT_DIR%
)
rem
rem check if the certificate exists and overwrite if requested

if EXIST "%AD_CERT_DIR%\root.crt" (
  set /p OVERWRITE= "%AD_CERT_DIR%\root.crt already exists - do you want to overwrite it (y/n)?"
  if "%OVERWRITE%" == "y" (
    del %AD_CERT_DIR%\root.crt
  ) else (
    echo %OVERWRITE% Not generating
    exit /b 0
  )
)
rem
rem - set the certificate directory (if different from current)
set PWD=%CD%
rem
rem basename / dirname http://secomparteosepierde.blogspot.com/2013/06/windows-console-basename-and-dirname.html
rem
rem - obtain the drive letter in case it's different from current
rem - remove /r as it seems unnecessary
for %%F in (%PWD%) do set PWD_DRIVE=%%~dF
for %%F in (%AD_CERT_DIR%) do set AD_CERT_DRIVE=%%~dF
%AD_CERT_DRIVE%
cd %AD_CERT_DIR%
certutil -ca.cert root.crt
%PWD_DRIVE%
cd %PWD%

set /p TRANSFER= "Do you want to transfer cert to database node now (y/n)?"
if "%TRANSFER%" == "y" (
  call 07-transfer-cert %ENV%
) else (
  echo Transfer database environment to database node: 05-transfer-cert %ENV%
)
