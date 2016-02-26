iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable --name allowGlobalConfirmation # stop the -y flag being needed for all "choco install"s

Write-Host "Installing Windows updates...let the hour long fun begin"
choco install pswindowsupdate
Import-Module PSWindowsUpdate

Get-WUInstall -IgnoreReboot -AcceptAll