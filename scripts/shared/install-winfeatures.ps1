#################################################################################
# Install IIS, MSMQ, WCF, .NET 4.5
#################################################################################

# To verify the installation this could use Get-WindowsFeature
Write-Host "Installing Web server role features (IIS, MSMQ, .NET 4.5)"
Install-WindowsFeature NET-Framework-Core
Install-WindowsFeature Web-Server -IncludeAllSubFeature
Install-WindowsFeature NET-Framework-Features -IncludeAllSubFeature
Install-WindowsFeature NET-Framework-45-ASPNET -IncludeAllSubFeature
Install-WindowsFeature Application-Server -IncludeAllSubFeature
Install-WindowsFeature MSMQ -IncludeAllSubFeature
Install-WindowsFeature WAS -IncludeAllSubFeature

#################################################################################
# Install .NET 4.6 and ARR
#################################################################################
Write-Host "Installing .NET 4.6"
choco install dotnet4.6

Write-Host "Installing ARRv3 and UrlRewrite2 via Web Platform Installer"
choco install webpicmd
webpicmd /Install /Products:"ARRv3_0,UrlRewrite2" /AcceptEULA

#################################################################################
# Notepad2 for RDP-based editing.
#################################################################################
choco install notepad2

#################################################################################
# Enable remote desktop and some default Windows explorer features
#################################################################################
Write-Host "Enabling remote desktop"
netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f

Write-Host "Customising Windows Explorer to be dev-friendly"
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' # careful with that :\, it a secret Powershell spell when inside ""
$advancedKey = "$key\Advanced"
$cabinetStateKey = "$key\CabinetState"

Set-ItemProperty -Path $advancedKey -Name HideFileExt -Value 0 -ErrorAction Ignore
Set-ItemProperty -Path $advancedKey -Name Hidden -Value 1 -ErrorAction Ignore
Set-ItemProperty -Path $advancedKey -Name ShowSuperHidden -Value 1 -ErrorAction Ignore
Set-ItemProperty -Path $cabinetStateKey -Name FullPath -Value 1 -ErrorAction Ignore