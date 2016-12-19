# Check for chocolatey and install it
if(-not $env:ChocolateyInstall -or -not (Test-Path "$env:ChocolateyInstall")){
    iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))
}

# Check for packer and install it
$hasPacker = chocolatey list -localonly | Select-String "packer"
if ($hasPacker -eq $null)
{
    choco install packer -y
}

# Take a survey
$aws_accesskey = $env:AWS_ACCESSKEY
$aws_secretkey = $env:AWS_SECRETKEY
$aws_ami_windows_id = "ami-771b4504"

$aws_ami_name = $env:aws_ami_name
$aws_security_group_id = $env:aws_security_group_id
$aws_subnet_id = $env:aws_subnet_id
$target = "aws-basewindows"

Write-Host "Before starting, make sure you have created a key pair called 'packer'" -ForegroundColor Green
Write-Host "This should be stored as packer.pem in this directory." -ForegroundColor Green

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

if (!$aws_ami_name)
{
    $aws_ami_name = Read-Host "Enter the name for your new AMI"
    $env:aws_ami_name = $aws_ami_name
}

$aws_ami_description = Read-Host "Enter a description for your new AMI (Windows Server 2016 base)"
if (!$aws_ami_description)
{
    $aws_ami_description = "Windows Server 2016 base"
}

$isTeamcity = Read-Host "Is this a teamcity agent (no)?"
if ($isTeamcity -eq "yes" -or $isTeamcity -eq "y")
{
    $target = "aws-teamcity"
}

if (!$aws_security_group_id)
{
    $aws_security_group_id = Read-Host "Enter a security group id"
    $env:aws_security_group_id = $aws_security_group_id
}

if (!$aws_subnet_id)
{
    $aws_subnet_id = Read-Host "Enter a subnet id"
    $env:aws_subnet_id = $aws_subnet_id
}

$start = get-date

$env:PACKER_LOG=1
$env:PACKER_LOG_PATH="packerlog.txt"
packer build -force -only="$target" `
                    -var "ami_name=$aws_ami_name" `
                    -var "ami_description=$aws_ami_description" `
                    -var "aws_accesskey=$aws_accesskey" `
                    -var "aws_secretkey=$aws_secretkey" `
                    -var "security_group_id=$aws_security_group_id" `
                    -var "subnet_id=$aws_subnet_id" `
                    -var "ami_id=$aws_ami_id" `
                    -var "associate_public_ip_address=false" `
                     "aws.json"

$end = get-date
$total = $end - $start
Write-Host "Took $total to complete"