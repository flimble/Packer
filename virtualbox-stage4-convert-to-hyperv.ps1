# Convert from OVF to hyper-v hard disk format
$hyperVDir = "output-virtualbox-stage4-hyper-v"
if(!(Test-Path $hyperVDir))
{
    Write-Host "Creating hyper-v output directory: $hyperVDir"
    mkdir $hyperVDir
}

$vboxDisk = Resolve-Path "output-virtualbox-stage3\*.vmdk"
$hyperVDisk = Join-Path $hyperVDir 'disk.vhd'

Write-Host "Exporting hyper-v disk to $hyperVDisk"
. "$env:programfiles\oracle\VirtualBox\VBoxManage.exe" clonehd $vboxDisk $hyperVDisk --format vhd #--variant fixed
