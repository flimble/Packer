if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

choco install packer -y

# Centos template thanks to https://github.com/geerlingguy/packer-centos-6
$start = get-date
packer build -force --only=vmware-iso centos7.2.json

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"
kill -name vmware-vmx -ErrorAction Ignore