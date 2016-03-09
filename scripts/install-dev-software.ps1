Write-Host "Installing developer software"
choco install windows-sdk-8.1
choco install git
choco install git.install
choco install poshgit
choco install nuget.commandline
choco install diffmerge
choco install google-chrome-x64
choco install firefox
choco install nodejs.install
choco install visualstudio2015professional
choco install resharper-platform -y
Start-Process -FilePath "C:\ProgramData\chocolatey\lib\resharper-platform\JetBrains.ReSharperUltimate.10.0.2.exe" -ArgumentList "/SpecificProductNames=ReSharper;dotTrace;dotCover;dotMemory;dotPeek /Silent=True" -Wait
choco install mssqlservermanagementstudio2014express