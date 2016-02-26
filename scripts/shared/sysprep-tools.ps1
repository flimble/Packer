function Join-Domain($domain, $user, $password)
{
    # Add the computer to the domain.
    # user should be a user who can add computers to the domain.
    $password= $password | ConvertTo-SecureString -asPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential($user,$password)
    Add-Computer -DomainName $domain -Credential $cred
}

function Invoke-SysPrep()
{
    # Disable the vagrant user
    $ObjUser = [ADSI]"WinNT://localhost/vagrant"; 
    $ObjUser.userflags = 2; 
    $ObjUser.setinfo(); 

    # Call sysprep
    C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /reboot /quiet /unattend:D:\Autounattend-sysprep.xml
}