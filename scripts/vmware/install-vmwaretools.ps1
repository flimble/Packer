# VMWare tools are required
# Unfortunately 'choco install vmware-tools' is out of date and fails
Write-Host "Downloading VMWare tools from Github"
wget https://github.com/TotalJobsGroup/Packer/raw/master/VMware-tools-10.0.0-3000743-x86_64.exe -OutFile D:\VMware-tools-10.0.0-3000743-x86_64.exe

Write-Host "Running D:\VMware-tools-10.0.0-3000743-x86_64.exe"
& D:\VMware-tools-10.0.0-3000743-x86_64.exe /s /v/qn