if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

choco install packer -y

# Extra logging
$env:PACKER_LOG=1
$env:PACKER_LOG_PATH="virtualbox-stage1.log"

$start = get-date
packer build -force -only="virtualbox-stage1-base" virtualbox.json

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"
