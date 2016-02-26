# Give it SSH
#choco install win32-openssh -params '"/SSHServerFeature"'

# This script is pending a tidy up
#################################################################################

Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -RemoteAddress Any
Enable-WSManCredSSP -Force -Role Server

Enable-PSRemoting -Force -SkipNetworkProfileCheck
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

#################################################################################
# windows powershell bootstrap script
$host.ui.RawUI.WindowTitle = "Bootstrapping Windows"

# supress network location Prompt
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force

# set network to private
$ifaceinfo = Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex $ifaceinfo.InterfaceIndex -NetworkCategory Private 

# disable windows defender CPU hog during build only works on win10
#Set-MpPreference -DisableRealtimeMonitoring $true -DisableArchiveScanning $true -DisableIOAVProtection $true

# enable winrm on http
set-wsmanquickconfig -force

#autostart
sc.exe config WinRM start=auto

# config winrm settings to be totally insecure and work with packer
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'

# configure powersaving and screen saver
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -change -monitor-timeout-ac 0
powercfg -hibernate OFF

start-sleep -s 120