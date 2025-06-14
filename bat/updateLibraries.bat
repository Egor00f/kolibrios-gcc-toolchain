set TOOLCHAIN_DIR=%1

wget -r --no-parent http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/
move /y builds.kolibrios.org\en_US\data\contrib\sdk\lib\* %TOOLCHAIN_DIR%\win32\mingw32\lib
rd /s /q builds.kolibrios.org
