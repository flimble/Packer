# VMWare tools are required
# Unfortunately 'choco install vmware-tools' is out of date and fails
Write-Host "Installing VMWare tools"
wget https://packages.vmware.com/tools/esx/latest/windows/x64/VMware-tools-10.0.0-3000743-x86_64.exe -OutFile D:\VMware-tools-10.0.0-3000743-x86_64.exe
& D:\VMware-tools-10.0.0-3000743-x86_64.exe /s