#################################################################################
# Install IIS, MSMQ, WCF, .NET 4.5
#################################################################################

# To verify the installation this could use Get-WindowsFeature
Write-Host "Installing Role 'NET-Framework-Core'"
Install-WindowsFeature NET-Framework-Core

Write-Host "Installing Role 'Web-Server'"
Install-WindowsFeature Web-Server -IncludeAllSubFeature

Write-Host "Installing Role 'NET-Framework-Features'"
Install-WindowsFeature NET-Framework-Features -IncludeAllSubFeature

Write-Host "Installing Role 'NET-Framework-45-ASPNET'"
Install-WindowsFeature NET-Framework-45-ASPNET -IncludeAllSubFeature

Write-Host "Installing Role 'Application-Server'"
Install-WindowsFeature Application-Server -IncludeAllSubFeature

Write-Host "Installing Role 'MSMQ'"
Install-WindowsFeature MSMQ -IncludeAllSubFeature

Write-Host "Installing Role 'WAS'"
Install-WindowsFeature WAS -IncludeAllSubFeature

#################################################################################
# Install .NET 4.6.2 and ARR
#################################################################################
Write-Host "Installing .NET 4.6.2"
choco install dotnet4.6.2

Write-Host "Installing Web Platform Installer (webpicmd)"
choco install webpicmd

# Sometimes webPI feeds are broken, this is a workaround... http://forums.iis.net/t/1231644.aspx?Unable+to+install+WebPlattformInstaller+on+W2012R2
$registryPath = "HKLM:\Software\Microsoft\webplatforminstaller"
if(!(Test-Path $registryPath))
{
    Write-Output "Creating registry key $registryPath..."
    New-Item -Path "HKLM:\Software\Microsoft" -Name "webplatforminstaller"
}

Write-Output "Changing feed target for WebPI..."
New-ItemProperty -Path $registryPath -Name "ProductXMLLocation" -Value "http://www.microsoft.com/web/webpi/5.0/webproductlist.xml" -PropertyType STRING -Force | Out-Null

Write-Host "Installing ARRv3 and UrlRewrite2 via Web Platform Installer (Take 2)"
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
