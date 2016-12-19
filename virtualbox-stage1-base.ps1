if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

# specific versions due to bugs in 0.12.1
choco install packer -y -version 0.12.0
choco install VirtualBox -y -version 5.1.8.20161116

# Extra logging
$env:PACKER_LOG=1
$env:PACKER_LOG_PATH="virtualbox-stage1.log"

$start = get-date
packer build -force -only="virtualbox-stage1-base" virtualbox.json

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"
