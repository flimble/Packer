Write-Output "Detecting correct drive..."
$disks = gwmi win32_logicaldisk
Write-Output "Detected disk: $disks"

$availableDisks = $disks | ? { $_.DeviceID -notmatch "[abc]:"}
Write-Output "Filtered: $availableDisks"

$vboxExtensions = "";
foreach ($disk in $availableDisks)
{
    $disk = $disk.DeviceID
    $vboxExtensions = Join-Path $disk "VBoxWindowsAdditions.exe"
    Write-Output "Testing for $vboxExtensions"
    if(Test-Path $vboxExtensions)
    {
        Write-Output "$vboxExtensions found..."
        break
    }
}

# we should hopefully have found the exe to run...
if(Test-Path $vboxExtensions)
{
    Write-Output "Executing $vboxExtensions..."
    Start-Process -FilePath "$vboxExtensions" -ArgumentList "/S" -Wait -PassThru # /S needs to be capital...
}
else
{
    throw "Unable to find guest addons... :("
}
