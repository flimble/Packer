#################################################################################
# Install IIS, MSMQ, WCF, .NET 4.5
#################################################################################

# To verify the installation this could use Get-WindowsOptionalFeature -Online | select FeatureName | sort FeatureName
Write-Host "Installing Web server role features (IIS, MSMQ, .NET 4.5)"
                                                                                          
Enable-WindowsOptionalFeature -FeatureName IIS-ApplicationDevelopment -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ApplicationInit -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ASP -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ASPNET -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ASPNET45 -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-BasicAuthentication -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-CertProvider -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-CGI -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ClientCertificateMappingAuthentication -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-CommonHttpFeatures -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-CustomLogging -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-DefaultDocument -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-DigestAuthentication -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-DirectoryBrowsing -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-HealthAndDiagnostics -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-HostableWebCore -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-HttpCompressionDynamic -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-HttpCompressionStatic -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-HttpErrors -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-HttpLogging -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-HttpRedirect -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-HttpTracing -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-IIS6ManagementCompatibility -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-IISCertificateMappingAuthentication -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-IPSecurity -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ISAPIExtensions -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ISAPIFilter -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-LegacyScripts -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-LegacySnapIn -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-LoggingLibraries -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ManagementConsole -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ManagementScriptingTools -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ManagementService -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-Metabase -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-NetFxExtensibility -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-NetFxExtensibility45 -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ODBCLogging -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-Performance -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-RequestFiltering -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-RequestMonitor -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-Security -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-ServerSideIncludes -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-StaticContent -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-URLAuthorization -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-WebDAV -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-WebServer -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-WebServerManagementTools -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-WebServerRole -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-WebSockets -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-WindowsAuthentication -Online -All
Enable-WindowsOptionalFeature -FeatureName IIS-WMICompatibility -Online -All

Enable-WindowsOptionalFeature -FeatureName MSMQ-ADIntegration -Online -All
Enable-WindowsOptionalFeature -FeatureName MSMQ-Container -Online -All
Enable-WindowsOptionalFeature -FeatureName MSMQ-DCOMProxy -Online -All
Enable-WindowsOptionalFeature -FeatureName MSMQ-HTTP -Online -All
Enable-WindowsOptionalFeature -FeatureName MSMQ-Multicast -Online -All
Enable-WindowsOptionalFeature -FeatureName MSMQ-Server -Online -All
Enable-WindowsOptionalFeature -FeatureName MSMQ-Triggers -Online -All

Enable-WindowsOptionalFeature -FeatureName WAS-ConfigurationAPI -Online -All
Enable-WindowsOptionalFeature -FeatureName WAS-NetFxEnvironment -Online -All
Enable-WindowsOptionalFeature -FeatureName WAS-ProcessModel -Online -All
Enable-WindowsOptionalFeature -FeatureName WAS-WindowsActivationService -Online -All
Enable-WindowsOptionalFeature -FeatureName WCF-HTTP-Activation -Online -All
Enable-WindowsOptionalFeature -FeatureName WCF-HTTP-Activation45 -Online -All
Enable-WindowsOptionalFeature -FeatureName WCF-MSMQ-Activation45 -Online -All
Enable-WindowsOptionalFeature -FeatureName WCF-NonHTTP-Activation -Online -All
Enable-WindowsOptionalFeature -FeatureName WCF-Pipe-Activation45 -Online -All
Enable-WindowsOptionalFeature -FeatureName WCF-Services45 -Online -All
Enable-WindowsOptionalFeature -FeatureName WCF-TCP-Activation45 -Online -All
Enable-WindowsOptionalFeature -FeatureName WCF-TCP-PortSharing45 -Online -All

#################################################################################
# Install .NET 4.6 and ARR
#################################################################################
Write-Host "Installing .NET 4.6"
choco install dotnet4.6

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
