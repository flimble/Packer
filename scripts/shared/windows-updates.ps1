# This file is called by Windows in the answer file on first run.
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable --name allowGlobalConfirmation # stop the -y flag being needed for all "choco install"s

choco install pswindowsupdate
Import-Module PSWindowsUpdate

Write-Host "Installing Windows updates. This will take over an hour"
Get-WUInstall -IgnoreReboot -AcceptAll

#################################################################################
# Enable WinRM
#################################################################################
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -RemoteAddress Any
Enable-WSManCredSSP -Force -Role Server
set-wsmanquickconfig -force

#autostart
sc.exe config WinRM start=auto

# Allow unencrypted
Enable-PSRemoting -Force -SkipNetworkProfileCheck
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'

#################################################################################
# Restart for the Windows Updates to be configured
#################################################################################
net stop winrm
Write-host "Sleeping for 1 minute, then restarting"
start-sleep -s 60
shutdown /r /c "packer restart" /t 5
