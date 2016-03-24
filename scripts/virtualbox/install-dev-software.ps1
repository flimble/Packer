Write-Output "Installing developer software"

# Git things
choco install git
#choco install poshgit # this is leaving powershell broken...which stops the next stage

# General Dev Tools
choco install nodejs.install

# Browsers
choco install firefox
choco install google-chrome-x64

# MS Building Tools
choco install windows-sdk-8.1
choco install nuget.commandline
choco install microsoft-build-tools

# SQL Tools
choco install mssqlservermanagementstudio2014express

# Build & Visual Studio
choco install visualstudio2015professional # if you get error 1603 then you are missing some windows updates

# VSPro package is continuing to install after it has "completed" so we are doing a sleep to ensure everything is caught
# https://chocolatey.org/packages/VisualStudio2015Professional#comment-2586516122
$minutesToSleep = 25
$secondsToSleep = 60 * $minutesToSleep
Write-Output "Sleeping for $minutesToSleep minutes due to dodgy VS Installer..."
Start-Sleep -s $secondsToSleep

choco install resharper-platform -y
$resharperInstaller = Resolve-Path "$env:ChocolateyInstall\lib\resharper-platform\JetBrains.ReSharperUltimate.*.exe"
Write-Output "Installing ReSharper Ultimate with lots of goodies: $resharperInstaller"
Start-Process -FilePath "$resharperInstaller" -ArgumentList "/SpecificProductNames=ReSharper;dotTrace;dotCover;dotMemory;dotPeek /Silent=True" -Wait
