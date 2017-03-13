if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

# specific versions due to bugs in 0.12.1
choco install packer -y -version 0.12.0
choco install VirtualBox -y -version 5.1.8.20161116

# Extra logging
$env:PACKER_LOG=1
$env:PACKER_LOG_PATH="virtualbox-win2016-stage2.log"

$start = get-date
$ovfName = Resolve-Path "output-virtualbox-win2016-stage1-base\*.ovf"
$ovfName = split-path $ovfName -leaf
packer build -force -only="virtualbox-win2016-stage2-devdesktop" -var "ovfsource=$ovfName" virtualbox_win2016.json

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"
