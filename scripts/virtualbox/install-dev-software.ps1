Write-Host "Installing developer software"
choco install windows-sdk-8.1

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
choco install nuget.commandline
choco install visualstudio2015professional
choco install resharper-platform -y
Start-Process -FilePath "C:\ProgramData\chocolatey\lib\resharper-platform\JetBrains.ReSharperUltimate.10.0.2.exe" -ArgumentList "/SpecificProductNames=ReSharper;dotTrace;dotCover;dotMemory;dotPeek /Silent=True" -Wait

# SQL Tools
choco install mssqlservermanagementstudio2014express
