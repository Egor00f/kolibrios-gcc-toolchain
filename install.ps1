#Requires -RunAsAdministrator

param(
	[string]$InstallPath='C:\MinGW\msys\1.0\home\autobuild\tools'
)

if (Get-Module -ListAvailable -Name 7Zip4PowerShell) 
{} 
else
{
	Install-Module -Name 7Zip4PowerShell
}

$LIBS_PATH = '$InstallPath\win32\mingw32\lib\'
$LIBS_URL = 'http://builds.kolibrios.org/en_US/data/contrib/sdk/lib/'


Write-Progress -Activity 'Installing toolchain' -Status 'Installing toolchain' -PercentComplete 0 -CurrentOperation 'Create the $InstallPath folder'

mkdir $InstallPath -Force


Write-Progress -Activity 'Installing toolchain' -Status 'Installing toolchain' -PercentComplete 1 -CurrentOperation 'Download the kos32-gcc toolchain'

Invoke-WebRequest http://ftp.kolibrios.org/users/Serge/new/Toolchain/msys-kos32-5.4.0.7z -OutFile $InstallPath\kos32-toolchain.7z


Write-Progress -Activity 'Installing toolchain' -Status 'Installing toolchain' -PercentComplete 20 -CurrentOperation 'Unpacking kos32-gcc toolchain'

Expand-7Zip -ArchiveFileName $InstallPath\kos32-toolchain.7z -TargetPath $InstallPath


Write-Progress -Activity 'Installing toolchain' -Status 'Installing libraries' -PercentComplete 40 -CurrentOperation 'Downloading libraries'

Invoke-WebRequest http://ftp.kolibrios.org/users/Serge/new/Toolchain/sdk-28-10-16.7z -OutFile $InstallPath\win32\mingw32\sdk-28-10-16.7z


Write-Progress -Activity 'Installing toolchain' -Status 'Installing libraries' -PercentComplete 50 -CurrentOperation 'Unpacking libraries'

Expand-7Zip -ArchiveFileName $InstallPath\win32\mingw32\sdk-28-10-16.7z -TargetPath $InstallPath\win32\mingw32\



Write-Progress -Activity 'Installing toolchain' -Status 'Installing libraries' -PercentComplete 60 -CurrentOperation "Download libraries"


$response  = Invoke-WebRequest -Uri $LIBS_URL -Method GET

$files = @( $response.Content -split [environment]::NewLine | ? { $_ -like '*tageswerte*.zip*' } | % { $_ -replace '^(.*>)(tages.*\.zip)<.*', '$2' } )

foreach( $file in $files ) {

    Invoke-WebRequest -Uri ($LIBS_URL + $file) -Method GET -OutFile ($LIBS_PATH + $file)
}

Write-Progress -Activity 'Installing toolchain' -Status 'Done!' -PercentComplete 99 -CurrentOperation "end"

