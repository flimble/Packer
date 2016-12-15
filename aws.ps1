if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

choco install packer -y

$aws_accesskey = $env:AWS_ACCESSKEY
$aws_secretkey = $env:AWS_SECRETKEY
$aws_ami_windows_id = "ami-771b4504"

if (!$aws_accesskey)
{
    $aws_accesskey = Read-Host "AWS access key"
    $env:AWS_ACCESSKEY = $aws_accesskey
    Write-Host "AWS access key now stored in env:AWS_ACCESSKEY"
}

if (!$aws_secretkey)
{
    $aws_secretkey = Read-Host "AWS secret key"
    $env:AWS_SECRETKEY = $aws_secretkey
    Write-Host "AWS secret key now stored in env:AWS_SECRETKEY"
}

$aws_ami_id = Read-Host "Enter an Windows AMI id ($aws_ami_windows_id)"
if (!$aws_ami_id)
{
    $aws_ami_id = $aws_ami_windows_id
}
$ami_name = Read-Host "Enter the name for your new AMI"

$security_group_id = Read-Host "Enter a security group id"
$subnet_id = Read-Host "Enter a subnet id"

$start = get-date

packer build -force -only="aws-basewindows" `
                    -var "ami_name=$ami_name" `
                    -var "aws_accesskey=$aws_accesskey" `
                    -var "aws_secretkey=$aws_secretkey" `
                    -var "security_group_id=$security_group_id" `
                    -var "subnet_id=$subnet_id" `
                    -var "ami_id=$aws_ami_id" `
                    -var "associate_public_ip_address=false" `
                     aws.json

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"