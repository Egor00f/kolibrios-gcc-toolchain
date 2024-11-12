# Установщик gcc тулчейна для KolibriOS

Просто устанавливает тулчейн C/C++ компилятора для KolinriOS от Serge.

Оригинальный скрипт для linux взят [по ссылке](http://board.kolibrios.org/viewtopic.php?p=76227&hilit=%D1%82%D1%83%D0%BB%D1%87%D0%B5%D0%B9%D0%BD#p76227) (скрипт был значительно изменён).

## Установка

Для установки требуются `7z` и `wget`. При выборе своего пути в любом случае будет создана папка win32 в выбранной папке. 

### Linux

Просто запустите `install.sh`.

Некоторые команды требуют sudo.

Или установите пакет. [Ссылка на пакет](https://git.kolibrios.org/Egor00f/-/packages/debian/kos32-gcc/) или в релизах.

Тулчейн по умолчанию устанавливается в папку `/home/autobuild/tools/win32`, но скрипт вас спросит перед установкой.

### Windows

Желательно чтобы вы перед установкой тулчейна установите msys из установщика MinGW.

Для windows есть установщик(посмотрите в релизах) или просто запустите `install.bat`. Рекомендуется запускать с повышенными правами.

wget для windows можно поискать в GnuWin32 например, 7z Нужно добавить в PATH. 

Тулчейн по умолчанию устанавливается в папку `C:/MinGW/msys/1.0/home/autobuild/tools/win32`, но вы можете изменить путь добавив аргумент - путь установки(пустой - путь по умолчанию).

## Сборка установщиков

Установщики полностью базируются на скриптах установки, так что без разницы что вы будете использовать скрипт или установщик, но установщики могут и удалить тулчейн.

Установщики собираются с помощью cmake (cmake просто потому что могу).

### Linux

Можно собрать deb пакет. Цель для сборки Package. Для сборки требуется `dpkg-deb`.

### Windows

Установщик собирается с помощью Inno Setup. Цель для сборки Installer. Для сборки требуется компилятор Inno Setup.

Если сборка не работает, добавьте папку Inno Setup (например: `C:\Programs Files\Inno Setup 6`) в PATH.
