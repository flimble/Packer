if (Test-Path "./win10-stage1/Windows 10 x64.vmx")
{
    $start = get-date
    packer build -force -only="vmware-win10-stage2" vmware-win10.json

    $end = get-date
    $total = $end - $start
    Write-Host "Took $total to complete"
    kill -name vmware-vmx -ErrorAction Ignore
}
else 
{
    Write-Host "./output-vmware-win10-stage1/vmware-win10-stage1.vmx was not found" -ForegroundColor Red
    Write-Host "Please run vmware-stage1-base.ps1 first." -ForegroundColor Red
}