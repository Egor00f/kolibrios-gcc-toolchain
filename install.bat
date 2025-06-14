rem@echo off

for /f %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"


set DEFAULT_TOOLCHAIN_DIR=C:\MinGW\msys\1.0\home\autobuild\tools

if [%1] == [] (
    set TOOLCHAIN_DIR=%DEFAULT_TOOLCHAIN_DIR%
)
else (
    set TOOLCHAIN_DIR=%1
)

echo %TOOLCHAIN_DIR%

Call :print_msg Create the %TOOLCHAIN_DIR% folder...

mkdir %TOOLCHAIN_DIR%

Call :print_ok Successfully!


cd bat

call :print_msg Download the kos32-gcc toolchain...

downloadToolchain %TOOLCHAIN_DIR%

Call :print_ok Successfully!



Call :print_msg Downloading libraries...

downloadLibraries.bat %TOOLCHAIN_DIR%

Call :print_ok Successfully!



Call :print_msg Updating libraries

updateLibraries %TOOLCHAIN_DIR%

Call :print_ok Successfully!



Call :print_msg Adding C:\MinGW\msys\1.0\home\autobuild\tools\win32\bin to PATH

set PATH=%PATH%;%TOOLCHAIN_DIR%%\win32\bin



Call :print_ok Installation was successful!



:print_msg
    echo %ESC%[34m%*%ESC%[%m
exit /b

:print_ok
    echo %ESC%[32m%*%ESC%[%m
exit /b
