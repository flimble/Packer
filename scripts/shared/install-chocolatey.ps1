#################################################################################
# Install Chocolatey, stop the -y flag being needed for all "choco install"
#################################################################################
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable --name allowGlobalConfirmation