if (Test-Path ./output-vmware-basewindows/vmware-basewindows.vmx)
{
    $start = get-date
    packer build -force -only="vmware-win10" vmware-win10.json

    $end = get-date
    $total = $end - $start
    Write-Host "Took $total to complete"
    kill -name vmware-vmx -ErrorAction Ignore
}
else 
{
    Write-Host "./output-vmware-basewindows/vmware-basewindows.vmx was not found" -ForegroundColor Red
    Write-Host "Please run vmware-stage1-base.ps1 first." -ForegroundColor Red
}