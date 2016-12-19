# See: http://stackoverflow.com/questions/21548566/how-to-add-more-than-one-machine-to-the-trusted-hosts-list-using-winrm

echo "Warning: this script allows you to connect to all hosts with WinRM"
Set-Item WSMan:\localhost\Client\TrustedHosts -Value '*'
Enable-PSRemoting -SkipNetworkProfileCheck
cd WSMan:\localhost\Client
set-item .\allowunencrypted $true
set-wsmanquickconfig -force

echo "Test WinRM works using this: "
echo "`$creds = Get-Credential"
echo "Enter-PSSession {<you aws IP> -Credential `$creds"