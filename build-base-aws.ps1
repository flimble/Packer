if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

choco install packer -y

$accessKey = $env:AWS_ACCESSKEY
$secretKey = $env:AWS_SECRETKEY

if (!$accessKey)
{
    $accessKey = Read-Host "AWS access key"
    $env:AWS_ACCESSKEY = $accessKey
}

if (!$secretKey)
{
    $secretKey = Read-Host "AWS secret key"
    $env:AWS_SECRETKEY = $secretKey
}

$amiName = Read-Host "Enter the name for your new AMI"

$start = get-date
packer build -force -only="aws-basewindows" -var "ami_name=$amiName" -var "aws_accesskey=$accessKey" -var "aws_secretkey=$secretKey" windows_2012_r2.json

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"