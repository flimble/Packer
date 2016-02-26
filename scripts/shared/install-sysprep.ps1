Copy-Item -Path A:\Autounattend-sysprep.xml -Destination D:\Autounattend-sysprep.xml; 
Copy-Item -Path A:\sysprep.ps1 -Destination D:\sysprep.ps1; 

# One approach: set sysprep-tools.ps1 to run the first time the VM boots.
# This would be perfect if you could rename the computer without restarting a second time.
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" -Name "Sysprep" -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -File D:\sysprep-tools.ps1";