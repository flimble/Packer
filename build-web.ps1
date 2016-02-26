if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

choco install packer -y

$start = get-date
packer build -force windows_2012_r2_web.json

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"