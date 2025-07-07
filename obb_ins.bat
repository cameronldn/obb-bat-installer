@echo off

echo(
echo *************************************************************************

set "_OBB_WILDCARD=*.OBB"
set "_APK_WILDCARD=*.APK"
set "project_name="
set "version_code="
set "reinstall="

if "%project_name%"=="" (
    set /P "project_name=Input project name (e.g. com.company.app): "
)
if "%version_code%"=="" (
    set /P "version_code=Input the build version code: "
)
if "%reinstall%"=="" (
    set /P "reinstall=Input if Reinstall (0 = No, 1 = Yes): "
)
echo(

for %%F in ("%cd%\*%_OBB_WILDCARD%") do (
    echo Found file:
    echo %%F
    echo(
    echo Renaming file:
    echo %%F
    echo to
    echo "main.%version_code%.%project_name%%%~xF"
    rename "%%F" "main.%version_code%.%project_name%%%~xF"
    set "OBB=main.%version_code%.%project_name%%%~xF"
    goto :end
)
:end
echo(

for %%F in ("%cd%\*%_APK_WILDCARD%") do (
    set "APK=%%~nF.apk"
    echo Found file:
    echo %%F
    echo APK: %APK%
    goto :end
)
:end
echo(

echo -----------------------------------------
echo adb devices
adb devices
echo -----------------------------------------
echo(

echo -----------------------------------------
echo Attempting to install:
echo %OBB%
echo %APK%
echo -----------------------------------------
echo(

echo -----------------------------------------
echo Creating obb directory if required... /sdcard/Android/obb/%project_name%
adb shell mkdir -p /sdcard/Android/obb/%project_name%
echo -----------------------------------------
echo(

echo -----------------------------------------
echo Pushing obb to directory... %OBB% /sdcard/Android/obb/%project_name%/
adb push -p %OBB% /sdcard/Android/obb/%project_name%/
echo -----------------------------------------
echo(

echo Installing APK...

echo Re-installing?:  %reinstall%

if %reinstall%==1 (
    adb install -r %APK%
) else (
    adb install %APK%
)
echo(

echo *************************************************************************
echo(