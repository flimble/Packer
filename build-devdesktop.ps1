if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

choco install packer -y

$start = get-date
$ovfName = Resolve-Path "output-virtualbox-basewindows\*.ovf"
$ovfName = split-path $ovfName -leaf
packer build -force -only="dev-desktop" -var "ovfsource=$ovfName" windows_2012_r2.json

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"

# Convert from OVF to hyper-v
$baseDir = $pwd
$hyperVDir = "$baseDir\hyper-v-output\Virtual Hard Disks"
if(!(Test-Path $hyperVDir))
{ 
    mkdir $hyperVDir
}

$vboxDisk = Resolve-Path "$baseDir\output-virtualbox-dev-desktop\*.vmdk"
$hyperVDisk = Join-Path $hyperVDir 'disk.vhd'
."$env:programfiles\oracle\VirtualBox\VBoxManage.exe" clonehd $vboxDisk $hyperVDisk --format vhd