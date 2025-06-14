
$installPath = Get-Content C:\ProgramData\Chocolatey\lib\kos32-gcc\install-path | Out-String | ConvertFrom-StringData

Remove-Item -LiteralPath $installPath -Force -Recurse
