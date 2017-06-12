$ErrorActionPreference = 'Stop';

$unzip_folder = $env:ProgramFiles
$install_folder = "$unzip_folder\telegraf"
$configDirectory = Join-Path $install_folder 'telegraf.d'
$packageName= 'telegraf'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url64      = 'https://dl.influxdata.com/telegraf/releases/telegraf-1.3.1_windows_i386.zip'
$fileLocation = Join-Path $install_folder 'telegraf.exe'

New-Item $configDirectory -type directory
 
If (Get-Service -Name "telegraf" -ErrorAction SilentlyContinue) {
    & $fileLocation --service uninstall
    Remove-Item $configDirectory
}
 
$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $unzip_folder
  fileType      = 'EXE'
  url64bit      = $url64
  file         = $fileLocation
 
  softwareName  = 'telegraf*'
 
  checksum64    = '8f68f75556512b28cd8fb2f06d9e2c7e9422f406d8466284e09974fe0805d91f'
  checksumType64= 'sha256'
  silentArgs    = "--config-directory `"$configDirectory`" --service install"

  validExitCodes= @(0)
}
 
Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage @packageArgs