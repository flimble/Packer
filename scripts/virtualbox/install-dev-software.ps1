Write-Host "Installing developer software"

# Lets get this over with first
choco install visualstudio2015professional # if you get error 1603 then you are missing some windows updates

# Git things
choco install git
choco install git.install -params '"/GitAndUnixToolsOnPath"'
choco install poshgit

# General Dev Tools
choco install diffmerge
choco install nodejs.install

# Browsers
choco install google-chrome-x64
choco install firefox

# MS Building Tools
choco install windows-sdk-8.1
choco install nuget.commandline

choco install resharper-platform -y

$resharperInstaller = Resolve-Path "$env:ChocolateyInstall\lib\resharper-platform\JetBrains.ReSharperUltimate.*.exe"
Write-Host "Installing ReSharper Ultimate with lots of goodies: $resharperInstaller"
Start-Process -FilePath "$resharperInstaller" -ArgumentList "/SpecificProductNames=ReSharper;dotTrace;dotCover;dotMemory;dotPeek /Silent=True" -Wait

# SQL Tools
choco install mssqlservermanagementstudio2014express