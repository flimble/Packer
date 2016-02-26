iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "Installing Windows updates...let the hour long fun begin"
choco install pswindowsupdate
Import-Module PSWindowsUpdate

Get-WUInstall -IgnoreReboot -AcceptAll