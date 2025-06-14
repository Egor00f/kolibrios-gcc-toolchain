CMAKE_MINIMUM_REQUIRED(VERSION 3.2)

project(
	KolibriOS-gcc-Toolchain-installer
	DESCRIPTION "Installer of gcc toolchain for KolibriOS"
)

add_custom_target(
	download_libraries
	COMMAND wget -q -N http://ftp.kolibrios.org/users/Serge/new/Toolchain/sdk-28-10-16.7z -O ${CMAKE_CURRENT_BINARY_DIR}/sdk-28-10-16.7z
	COMMAND wget -r --no-parent -q http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/
	COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/lib
	COMMAND mv ${CMAKE_CURRENT_BINARY_DIR}/builds.kolibrios.org/en_US/data/contrib/sdk/lib/* ${CMAKE_CURRENT_BINARY_DIR}/lib
	COMMAND rm -R ${CMAKE_CURRENT_BINARY_DIR}/builds.kolibrios.org
	COMMENT "Download libraries"
	OUTPUT
		${CMAKE_CURRENT_BINARY_DIR}/sdk-28-10-16.7z
	BYPRODUCTS
		${CMAKE_CURRENT_BINARY_DIR}/sdk-28-10-16.7z
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

add_custom_target(
	archive_libraries
	COMMAND 7z x -y -bso0 -bsp0 ${CMAKE_CURRENT_BINARY_DIR}/sdk-28-10-16.7z -o${CMAKE_CURRENT_BINARY_DIR}
	COMMAND 7z a -bso0 -bsp0 ${CMAKE_CURRENT_BINARY_DIR}/lib.7z ${CMAKE_CURRENT_BINARY_DIR}/lib
	COMMENT "Add libraries to archive"
	OUTPUT
		${CMAKE_CURRENT_BINARY_DIR}/lib.7z
	BYPRODUCTS
		${CMAKE_CURRENT_BINARY_DIR}/lib.7z
	DEPENDS
		${CMAKE_CURRENT_BINARY_DIR}/sdk-28-10-16.7z
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

add_custom_target(
	download_linux
	COMMAND wget http://ftp.kolibrios.org/users/Serge/new/Toolchain/x86_64-linux-kos32-5.4.0.7z -q -O ${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-linux.7z
	COMMAND wget http://board.kolibrios.org/download/file.php?id=8301libisl.so.10.2.2.7z -q -O ${CMAKE_CURRENT_BINARY_DIR}/libisl.so.10.2.2.7z
	COMMENT "Download linux toolchain"
	OUTPUT
		${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-linux.7z
		${CMAKE_CURRENT_BINARY_DIR}/libisl.so.10.2.2.7z
	BYPRODUCTS
		${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-linux.7z
		${CMAKE_CURRENT_BINARY_DIR}/libisl.so.10.2.2.7z
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

add_custom_target(
	download_windows
	COMMAND wget http://ftp.kolibrios.org/users/Serge/new/Toolchain/msys-kos32-5.4.0.7z -q -O ${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-win.7z
	COMMENT "Download windows toolchain"
	OUTPUT
		${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-win.7z
	BYPRODUCTS
		${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-win.7z
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

add_custom_target(
	extract_linux
	COMMAND 7z x -y -bso0 -bsp0 ${CMAKE_CURRENT_BINARY_DIR}/libisl.so.10.2.2.7z
	COMMENT "Extract linux archives"
	OUTPUT
		${CMAKE_CURRENT_BINARY_DIR}/libisl.so.10.2.2
	BYPRODUCTS
		${CMAKE_CURRENT_BINARY_DIR}/libisl.so.10.2.2
	DEPENDS 
		${CMAKE_CURRENT_BINARY_DIR}/libisl.so.10.2.2.7z
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

add_custom_target(
	configureDebPackage
	COMMENT "Setup debian package"
	COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_CURRENT_BINARY_DIR}/package
	COMMAND cp -rf ${CMAKE_CURRENT_SOURCE_DIR}/package/ ${CMAKE_CURRENT_BINARY_DIR}/package
	COMMAND chmod -R 775 ${CMAKE_CURRENT_BINARY_DIR}/package
	COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/package/usr/lib/x86_64-linux-gnu
	COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/package/home/autobuild/tools
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	OUTPUT
		${CMAKE_CURRENT_SOURCE_DIR}/package/
	BYPRODUCTS
		${CMAKE_CURRENT_BINARY_DIR}/package/
)


add_custom_target(
	deb
	COMMAND cp -f ${CMAKE_CURRENT_BINARY_DIR}/libisl.so.10.2.2 ${CMAKE_CURRENT_BINARY_DIR}/package/usr/lib/x86_64-linux-gnu/libisl.so.10.2.2
	COMMAND cp -f ${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-linux.7z ${CMAKE_CURRENT_BINARY_DIR}/package/home/autobuild/tools
	COMMAND cp -f ${CMAKE_CURRENT_BINARY_DIR}/lib.7z ${CMAKE_CURRENT_BINARY_DIR}/package/home/autobuild/tools
	COMMAND dpkg-deb --build ${CMAKE_CURRENT_BINARY_DIR}/package ${CMAKE_CURRENT_BINARY_DIR}/package.deb
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	COMMENT "Build deb package"
	OUTPUT
		${CMAKE_CURRENT_BINARY_DIR}/package.deb
	DEPENDS
		${CMAKE_CURRENT_BINARY_DIR}/libisl.so.10.2.2
		${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-linux.7z
		${CMAKE_CURRENT_BINARY_DIR}/lib.7z
		configureDebPackage
)

add_custom_target(
	Installer
	COMMAND 7z x ${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-win.7z -o ${CMAKE_CURRENT_BINARY_DIR}
	COMMAND iscc /O"${CMAKE_CURRENT_BINARY_DIR}" ${CMAKE_CURRENT_SOURCE_DIR}/installator.iss 
	COMMENT "Build windows installer"
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	SOURCES
		${CMAKE_CURRENT_SOURCE_DIR}/installator.iss
		${CMAKE_CURRENT_SOURCE_DIR}/LICENSE
		${CMAKE_CURRENT_SOURCE_DIR}/README.md
)

add_custom_target(
	choco
	COMMAND cp -f ${CMAKE_CURRENT_BINARY_DIR}/kos32-toolchain-win.7z ${CMAKE_CURRENT_SOURCE_DIR}/chocolatey/tools
	COMMAND choco pack
	WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/chocolatey
	COMMENT "Build chocolatey package"
	SOURCES
		${CMAKE_CURRENT_SOURCE_DIR}/chocolatey/kos32-gcc.nuspec
		${CMAKE_CURRENT_SOURCE_DIR}/chocolatey/tools/chocolateyInstall.ps1
		${CMAKE_CURRENT_SOURCE_DIR}/chocolatey/tools/chocolateyUninstall.ps1
)
