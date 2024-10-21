@echo off
setlocal

set START_DIR=%~dp0
set path=%START_DIR%;%path%

set BIN_DIR=%START_DIR%..\app\p5dms
set path=%BIN_DIR%;%path%

rem get absolute path of bin directory
pushd "%BIN_DIR%"
set BIN_DIR=%cd%
popd

set WORKING_DIR=%START_DIR%..

rem get absolute path of working directory
pushd "%WORKING_DIR%"
set WORKING_DIR=%cd%
popd

set WDS_CONFIG_DIR=%WORKING_DIR%\config\p5dms
echo %WDS_CONFIG_DIR%

set WORKING_DIR=%WORKING_DIR%\runtime

set LOG_DIR=%WORKING_DIR%\logs

if "%1%"=="" (
    echo "usage: %0% <tenantid>"
    goto :end 
)

set TENANT=%1%
set TENANTCONFIG=%WDS_CONFIG_DIR%\tenants\%TENANT%.yaml

if not exist %TENANTCONFIG% (
    echo %TENANT% is not a tenant. No configuration available: %TENANTCONFIG%
    goto :end 
)

(set LF=^

)

echo "URL"
echo %WDS_DBAGENT_URL% ist the dbagent url 

set WDSERMCONNECT=p5dmsERMConnect_%TENANT%
set WDSDBAGENT=p5dmsDBAgent_%TENANT%

rem erm connector setup 
nssm install %WDSERMCONNECT% "%BIN_DIR%\wds_ermconnect.exe" 
nssm set %WDSERMCONNECT% AppDirectory "%WORKING_DIR%"
nssm set %WDSERMCONNECT% DisplayName "Wilken P/5 ERM Connector for %TENANT%"
nssm set %WDSERMCONNECT% Description "Wilken P/5 ERM Connector for %TENANT%"
nssm set %WDSERMCONNECT% Start SERVICE_DELAYED_AUTO_START
nssm set %WDSERMCONNECT% AppStdout "%LOG_DIR%\%TENANT%_ermconnect.log"
nssm set %WDSERMCONNECT% AppStderr "%LOG_DIR%\%TENANT%_ermconnect.log"
nssm set %WDSERMCONNECT% AppEnvironmentExtra WDS_CONFIG_DIR=%WDS_CONFIG_DIR%^%LF%%LF%NODE_TLS_REJECT_UNAUTHORIZED=0^%LF%%LF%WDS_TENANT_CONFIG=%TENANT%^%LF%%LF%WDS_RUNTIME_DIR=%WORKING_DIR%\p5dms\%TENANT%

rem db agent setup 
nssm install %WDSDBAGENT% "%BIN_DIR%\wds_db_agent.exe" 
nssm set %WDSDBAGENT% AppDirectory "%WORKING_DIR%"
nssm set %WDSDBAGENT% DisplayName "Wilken P/5 DB Agent for %TENANT%"
nssm set %WDSDBAGENT% Description "Wilken P/5 DB Agent for %TENANT%"
nssm set %WDSDBAGENT% Start SERVICE_DELAYED_AUTO_START
nssm set %WDSDBAGENT% AppStdout "%LOG_DIR%\%TENANT%_dbagent.log"
nssm set %WDSDBAGENT% AppStderr "%LOG_DIR%\%TENANT%_dbagent.log"
nssm set %WDSDBAGENT% AppEnvironmentExtra WDS_CONFIG_DIR=%WDS_CONFIG_DIR%^%LF%%LF%NODE_TLS_REJECT_UNAUTHORIZED=0^%LF%%LF%WDS_TENANT_CONFIG=%TENANT%^%LF%%LF%WDS_RUNTIME_DIR=%WORKING_DIR%\p5dms\%TENANT%


:end
endlocal
