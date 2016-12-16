$chocolateySource = "http://nuget.tjgdev.ds:7272/nuget/Chocolatey"
Write-Output "Disabling default Chocolatey source..."
choco source disable -name "chocolatey"
Write-Output "Adding proget Chocolatey source... $chocolateySource"
choco source add -n "tjgdev-proget" -s $chocolateySource -priority 999

Write-Output "Installing developer software"

# Git things
choco install git

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
# if you get error 1603 then you are missing some windows updates
choco install visualstudio2015professional

choco install resharper-platform -y
$resharperInstaller = Resolve-Path "$env:ChocolateyInstall\lib\resharper-platform\JetBrains.ReSharperUltimate.*.exe"
Write-Output "Installing ReSharper Ultimate with lots of goodies: $resharperInstaller"
Start-Process -FilePath "$resharperInstaller" -ArgumentList "/SpecificProductNames=ReSharper;dotTrace;dotCover;dotMemory;dotPeek /Silent=True" -Wait -PassThru

choco install dotnetcore-sdk -pre

Write-Output "Ensuring password doesn't expire..."
&net accounts /maxpwage:unlimited
Write-Output "Done."
