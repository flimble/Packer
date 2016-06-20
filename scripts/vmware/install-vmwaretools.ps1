#################################################################################################
# Install VMWare tools from the Github repo (don't use choco or the VMWare url as they're broken).
#################################################################################################
$outFile = "C:\VMware-tools-10.0.0-3000743-x86_64.exe"

Write-Host "Running C:\VMware-tools-10.0.0-3000743-x86_64.exe"
& "$outFile" /s /v/qn REBOOT=ReallySuppress