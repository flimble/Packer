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

# Microsoft SQL Server 2016 Express
choco install sql-server-express

# Microsoft SQL Server Management Studio
choco install sql-server-management-studio

# Build & Visual Studio
# if you get error 1603 then you are missing some windows updates
##choco install visualstudio2017professional -pre # install RC - until match 7th
$outputDir = Join-Path $env:TEMP "\Dev-Vm\Installers\"
md -Force $outputDir | Out-Null

$output = Join-Path $outputDir "vs_professional.exe"
$vsArgs = '--installPath "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional" ' +
'--productId Microsoft.VisualStudio.Product.Professional ' +
'--locale en-US ' +
'--add Microsoft.VisualStudio.Workload.CoreEditor ' +
'--add Microsoft.VisualStudio.Workload.ManagedDesktop ' +
'--add Microsoft.VisualStudio.Workload.NetCoreTools ' +
'--add Microsoft.VisualStudio.Workload.NetWeb ' +
'--add Microsoft.VisualStudio.Workload.Node ' +
'--add Component.GitHub.VisualStudio ' +
'--includeRecommended ' +
'--includeOptional ' +
'--quiet ' +
'--norestart ' +
'--wait'

Write-Output "##### VISUAL STUDIO 2017 #####"
Write-Output "Downloading..."
Invoke-WebRequest -Uri "https://download.microsoft.com/download/0/2/7/0271BCD5-7A78-41F9-BABE-2194B9B83840/vs_professional.exe" -OutFile $output
Write-Output "Installer file location: " $output
Write-Output "Installing..."
$process = (Start-Process -FilePath $output -ArgumentList $vsArgs -Wait)
Write-Output "Installation finsihed! Process finished with return code: " $LastExitCode

choco install resharper-platform -y
$resharperInstaller = Resolve-Path "$env:ChocolateyInstall\lib\resharper-platform\JetBrains.ReSharperUltimate.*.exe"
Write-Output "Installing ReSharper Ultimate with lots of goodies: $resharperInstaller"
Start-Process -FilePath "$resharperInstaller" -ArgumentList "/VsVersion=15.0 /SpecificProductNames=ReSharper;dotTrace;dotCover;dotMemory;dotPeek /Silent=True" -Wait -PassThru

# VS 2017 doesn't install 4.6.2 on OSes < 10.0.14393. Exact error from VS log:
# Marking package Microsoft.Net.4.6.2.SDK as not applicable due to reasons: The current OS Version '6.3.9600.0' is not in the supported version range '10.0.14393'.
# Remove this if using WS-2016 
choco install netfx-4.6.2-devpack

choco install dotnetcore-sdk

Write-Output "Ensuring password doesn't expire..."
&net accounts /maxpwage:unlimited
Write-Output "Done."
