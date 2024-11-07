#!/bin/bash

# Written by turbocat2001 (Maxim Logaev)
# Installation steps described by maxcodehack (Maxim Kuzmitsky)

set -e

print_msg(){
    echo -e "\e[34m$1\e[0m"
}

print_ok(){
    echo -e "\e[32m$1\e[0m"
}

print_err(){
    echo -e "\e[31m$1\e[0m"
    exit
}

check_utils(){
    printf "%s: " $1
    if command -v $1 &> /dev/null
    then
        print_ok "ok\r"
    else
        print_err "no\r"
    fi
}


print_msg "Checking utilities..."



check_utils wget
check_utils 7z



print_msg "Create the /home/autobuild folder..."

sudo rm -rf ~/autobuild /home/autobuild
mkdir -p ~/autobuild/tools
sudo ln -sf  ~/autobuild /home/autobuild

print_ok "Successfully!"



print_msg "Download the kos32-gcc toolchain..."

wget http://ftp.kolibrios.org/users/Serge/new/Toolchain/x86_64-linux-kos32-5.4.0.7z -q -O ~/autobuild/tools/kos32-toolchain.7z

print_ok "Successfully!"



print_msg "Extracting files ..."

cd ~/autobuild/tools/
7z x -y kos32-toolchain.7z
rm -rf kos32-toolchain.7z

print_ok "Successfully!"



print_msg "Downloading libraries..."

cd ~/autobuild/tools/win32/mingw32
wget http://ftp.kolibrios.org/users/Serge/new/Toolchain/sdk-28-10-16.7z -q -O sdk-28-10-16.7z
7z x -y sdk-28-10-16.7z
rm -rf sdk-28-10-16.7z

print_ok "Successfully!"



print_msg "Updating libraries"

cd lib
wget http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/libdll.a -q -O libdll.a
wget http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/libfreetype.a -q -O libfreetype.a
wget http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/libc.dll.a -q -O libc.dll.a
wget http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/libSDLn.a -q -O libSDLn.a
wget http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/libcurses.a -q -O libcurses.a 
wget http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/libz.dll.a -q -O libz.dll.a
wget http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/libogg.a -q -O libogg.a
wget http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/libvorbis.a -q -O libvorbis.a
wget http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/libopenjpeg.a -q -O libopenjpeg.a

print_ok "Successfully!"



print_msg "Downloading libisl..."

cd /tmp
sudo wget http://board.kolibrios.org/download/file.php?id=8301libisl.so.10.2.2.7z -q -O /tmp/libisl.so.10.2.2.7z
sudo 7z x -y libisl.so.10.2.2.7z

if ! [ -d /usr/lib/x86_64-linux-gnu/ ]; then
    sudo mkdir -p /usr/lib/x86_64-linux-gnu/
fi

sudo mv /tmp/libisl.so.10.2.2 /usr/lib/x86_64-linux-gnu/libisl.so.10.2.2
sudo ln -sf /usr/lib/x86_64-linux-gnu/libisl.so.10.2.2 /usr/lib/x86_64-linux-gnu/libisl.so.10
sudo ln -sf /usr/lib/x86_64-linux-gnu/libisl.so.10.2.2 /usr/lib/libisl.so.10
sudo chmod go-w /usr/lib/x86_64-linux-gnu/libisl.so.10 
sudo chmod go-w /usr/lib/x86_64-linux-gnu/libisl.so.10.2.2

print_ok "Successfully!"


print_msg "Fixing libmpfr..."

sudo ln -sf /usr/lib/x86_64-linux-gnu/libmpfr.so.6 /usr/lib/x86_64-linux-gnu/libmpfr.so.4
sudo ln -sf /usr/lib/libmpfr.so.6 /usr/lib/libmpfr.so.4

print_ok "Successfully!"


if ! grep -q 'export PATH=$PATH:/home/autobuild/tools/win32/bin' ~/.bashrc; then
  export PATH=$PATH:/home/autobuild/tools/win32/bin
  print_msg "Adding '/home/autobuild/tools/win32/bin' to '~/.bashrc'"
  echo 'export PATH=$PATH:/home/autobuild/tools/win32/bin' >> ~/.bashrc
fi

print_ok "Installation was successful!"