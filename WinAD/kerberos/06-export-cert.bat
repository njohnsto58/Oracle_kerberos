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
if EXIST "%AD_CERT_DIR%\root.crt" (
  set /p OVERWRITE= "%AD_CERT%\root.crt already exists - do you want to overwrite it (y/n)?"
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
for /r %%F in (%PWD%) do set PWD_DRIVE=%%~dF
for /r %%F in (%AD_CERT_DIR%) do set AD_CERT_DRIVE=%%~dF
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