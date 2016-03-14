if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

choco install packer -y

# Extra logging
$env:PACKER_LOG=1
$env:PACKER_LOG_PATH="virtualbox-stage2.log"

$start = get-date
$ovfName = Resolve-Path "output-virtualbox-stage1-base\*.ovf"
$ovfName = split-path $ovfName -leaf
packer build -force -only="virtualbox-stage2-devdesktop" -var "ovfsource=$ovfName" virtualbox.json

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"
