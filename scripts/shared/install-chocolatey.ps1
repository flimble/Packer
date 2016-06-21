#################################################################################
# Install Chocolatey, stop the -y flag being needed for all "choco install"
#################################################################################
$env:chocolateyVersion = '0.9.9.12' # Install sepecific version as later 0.9.10.* brakes PSWindowsUpdate
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable --name allowGlobalConfirmation
