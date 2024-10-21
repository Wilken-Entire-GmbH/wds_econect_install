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

set WDSERMCONNECT=p5dmsERMConnect_%TENANT%
set WDSDBAGENT=p5dmsDBAgent_%TENANT%

echo status of %WDSERMCONNECT%
nssm status %WDSERMCONNECT%

echo status of %WDSDBAGENT%
nssm status %WDSDBAGENT%

:end
endlocal