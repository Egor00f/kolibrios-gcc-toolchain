set TOOLCHAIN_DIR=%1


wget http://ftp.kolibrios.org/users/Serge/new/Toolchain/sdk-28-10-16.7z -O %TOOLCHAIN_DIR%\win32\mingw32\sdk-28-10-16.7z

7z x -y %TOOLCHAIN_DIR%\win32\mingw32\sdk-28-10-16.7z -o%TOOLCHAIN_DIR%\win32\mingw32
