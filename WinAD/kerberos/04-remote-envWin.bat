@echo off
rem
rem create the remote Win Client environment file
rem
call AD.bat
set REMOTE_ENV_FILE=00_env_WINClient.bat
echo   rem >>%REMOTE_ENV_FILE%
echo   rem AD Container MUST NOT have the DOMAIN_DN (this will be added later) >>%REMOTE_ENV_FILE%
echo   rem >>%REMOTE_ENV_FILE%
echo   set AD_NODE=%AD_NODE% >>%REMOTE_ENV_FILE%
echo   set AD_DOMAIN="%AD_DOMAIN%" >>%REMOTE_ENV_FILE%
echo   set AD_DOMAIN_DN="%AD_DOMAIN_DN%" >>%REMOTE_ENV_FILE%
echo   set AD_CONTAINER="%AD_CONTAINER%" >>%REMOTE_ENV_FILE%
echo   DB_DOMAIN_REALMS=(%DB_DOMAIN_REALMS%) >>%REMOTE_ENV_FILE%
echo   AD_CERT_DIR=%AD_CERT_DIR% >>%REMOTE_ENV_FILE%
move %REMOTE_ENV_FILE% WinClient