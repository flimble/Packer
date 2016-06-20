if (Test-Path ./output-vmware-webserver/vmware-webserver.vmx)
{
    $start = get-date
    packer build -force -only="vmware-buildmachine" vmware.json

    $end = get-date
    $total = $end - $start
    Write-Host "Took $total to complete"
    kill -name vmware-vmx -ErrorAction Ignore
}
else
{
    Write-Host "./output-vmware-webserver/vmware-webserver.vmx was not found" -ForegroundColor Red
    Write-Host "Please run vmware-stage2-webserver.ps1 first." -ForegroundColor Red  
}
