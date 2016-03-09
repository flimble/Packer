function Join-Domain($domain, $user, $password)
{
    # Add the computer to the domain.
    # user should be a user who can add computers to the domain.
    $password= $password | ConvertTo-SecureString -asPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential($user,$password)
    Add-Computer -DomainName $domain -Credential $cred
}

function Disable-PackerAccount()
{
    # Disable the packer user
    $ObjUser = [ADSI]"WinNT://localhost/packer"; 
    $ObjUser.userflags = 2; 
    $ObjUser.setinfo(); 
}

function Invoke-SysPrep()
{
    # Call sysprep
    C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /reboot /quiet /unattend:D:\Autounattend-sysprep.xml
}

function Update-LocalAdminPassword($password)
{
    $admin=[adsi]'WinNT://localhost/Administrator';
    $admin.SetPassword($password)
}