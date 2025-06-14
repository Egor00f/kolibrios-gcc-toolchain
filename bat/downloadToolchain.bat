set TOOLCHAIN_DIR=%1

wget http://ftp.kolibrios.org/users/Serge/new/Toolchain/msys-kos32-5.4.0.7z -O %TOOLCHAIN_DIR%\kos32-toolchain.7z

7z x -y  %TOOLCHAIN_DIR%\kos32-toolchain.7z -o%TOOLCHAIN_DIR%
