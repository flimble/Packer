# Convert from OVF to hyper-v hard disk format
$hyperVDir = "output-virtualbox-devdesktop\hyper-v-output\Virtual Hard Disks"
if(!(Test-Path $hyperVDir))
{ 
    mkdir $hyperVDir
}

$vboxDisk = Resolve-Path "output-virtualbox-devdesktop\*.vmdk"
$hyperVDisk = Join-Path $hyperVDir 'disk.vhd'
."$env:programfiles\oracle\VirtualBox\VBoxManage.exe" clonehd $vboxDisk $hyperVDisk --format vhd