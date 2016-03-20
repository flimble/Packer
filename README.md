# Packer
This repository is a set of [Packer](packer.io) files for creating Windows 2012 R2 templates on VMWare/vSphere and Hyper-V (via VirtualBox).

### Pre-requisites

- en_windows_server_2012_r2_with_update_x64_dvd_6052708.iso from MSDN/Technet
- VirtualBox or VMWare Professional or both.

#### Stages

The build up of the images is done in stages:

1. Install Windows from the ISO, run Windows update, enable WinRM.
2. Enable the Windows feature roles like IIS, install software
3. Install our own applications (these scripts aren't part of this repository).
4. *(Hyper-V and VirtualBox only)* convert the disk to Hyper-V format.

Each stage feeds from the previous stage by launching VMWare/VirtualBox/AWS using the VM image or AMI from the previous stage. This means you can update an image quickly with new software by skipping the long-winded Windows install-and-update stage, and role installation.

### Conventions/folder structure

- `.json` file - contains 4 Packer definitions. There are 2 definitions per VM: 
 1. Creates the base Windows hard drive image and installs 167+ Windows updates on it.
 2. Takes the output from 1) and installs Windows features like IIS and software.
- `scripts` folder - contains Powershell scripts for the two stages. Windows updates are done via the answer file, as WinRM can't run Windows updates. The rest is done via WinRM in Packer.
- `answerfiles` - This contains the Windows answer file that Windows needs for automated setups. It contains a default user "packer/packer" and volume licence keys from Microsoft KMS.
- `vmtype_stageN_xxx.ps` - These scripts run packer targetting the `.json` file and one of the named builders.

#### Disks

Each definition has 120gb hard drive. This has two partitions - 80gb for Windows on C:, and 40gb for the D: drive which is best practice for website folders. 

The AWS definition does this using two drives/volumes instead of one.

#### VMWare (vSphere)

The vSphere Packer builder section of the json file is for creating servers, usually web servers. This is done by creating VMWare .vmx files using Packer and VMWare Professional (it's about £100 a licence).

#### VirtualBox/Hyper-V

The VirtualBox Packer builder definition in the json file is for creating a developer desktop, it is converted from VirtualBox to HyperV for performance benefits (that are negligible according to some, massive according to others). This is done in the stage4 script.

#### AWS

The AWS builder definition in the JSON file creates an AMI based off the Amazon Windows 2012 r2 AMI. Like the VMWare builder, it installs various Windows Server features. As the Amazon AMI is already updated, it doesn't need to run Windows the update stage. It enables WinRM and partitions the disks as part of its AWS user date file (AWS's equivalent to the answer file).

### Getting started

- Make sure the MSDN Windows 2012 R2 ISO is in the /iso/ folder ("en_windows_server_2012_r2_with_update_x64_dvd_6052708.iso"). 
- You will need VirtualBox or VMWare professional installed to run the scripts.

### The story of the Packer journey

:gun: :gun: :gun: :gun: :gun:  

There have been quite a few hicups, learnings and annoyances on the way:

- Number of new Windows Updates since the initial commit: 160 -> 194
- Hours spent waiting for Windows to update: 40?
- OVFtool.exe has some bad error messages
- Vagrant's vSphere plugin is broken (see below)
- VMWare tools doesn't appear to install when done via Packer, it hangs (Windows 10).
- VMWare tools on the VMWare site only has the latest version, killing scripts relying on older-versions.
- You only need to use Boxstarter for older Windows Servers (< 2012)
- Sysprep, the SID gift that keeps on giving.
- OpenSSH isn't necessary, plus there is a Microsoft implementation now (but it doesn't work with Vagrant).
- You shall not get an updated (official) Win2012 Server ISO, you have to spend an hour in Windows Update every time.
- WinRM needs a huge ceremony before you can connect to the VM (Packer does this for you).
- You can't run Windows updates inside WinRM.

### Resources/references

Most of this repository was built from a huge amount of open source examples/tools/hacks to get the bitty Windows automation tacked together.

- [Joe Fitzgerald](https://github.com/joefitzgerald/packer-windows)
- [Sysprep'ing](https://gist.github.com/joefitzgerald/6253368 and https://gist.github.com/joefitzgerald/6254582)
- [Packer community templates](https://github.com/mefellows/packer-community-templates)
- [Boxcutter](https://github.com/boxcutter/windows)
- [Vagrant vSphere plugin, currently broken](https://github.com/nsidc/vagrant-vsphere)
- [Chocolatey](https://chocolatey.org/)
- [Boxstarter](http://boxstarter.org/WinConfig)
- [Windows KMS keys](https://technet.microsoft.com/en-us/library/jj612867.aspx)

### Extra VMWare notes

#### Pushing the VMX file into vSphere and marking it as a template

And the tools to push the VMX file into vSphere:

- [OVF Tool](https://my.vmware.com/web/vmware/details?productId=352&downloadGroup=OVFTOOL350)

You need a very elaborate set of of roles to push to VSphere (see below) to run ovftool.

	# If you get errors like 'Found no hosts in target cluster to deploy on. Cannot deploy to an empty cluster' make sure you have the correct permissions

	$username = $env:USERNAME

	ovftool --acceptAllEulas `
	--overwrite=true `
	--vCloudTemplate `
	--X:logLevel=verbose `
	--noSSLVerify=false `
	--datastore={DATASTORE-NAME} `
	--diskMode=thick `
	"--name={TEMPLATE-NAME}" `
	--network={NETWORK=NAME} `
	"--vmFolder=Folder1/Folder2" `
	output-vmware-iso\packer-vmware-iso.vmx `
	"vi://$username%40DOMAIN.COM@{SERVER}/Path/To/Your/Template-Container"


##### VSphere Permissions

These are courtesy of [this blog](http://www.virtxpert.com/creating-vcenter-role-vsphere-vagrant-provider/). You may also need read on ALL the data centers too.

#####Role settings

- Datastore  
 - Allocate space  
 - Browse datastore  
 - Remove file  
 - Update virtual machine file  
- Global  
 - Log event  
 - Cancel task  
- Host  
 - Create virtual machine  
 - Delete virtual machine  
 - Reconfigure virtual machine  
- Network  
 - Assign network  
- Resource  
 - Assign virtual machine to resource pool  
- Tasks  
 - Create task  
 - Update task  
- Virtual machine  
 - Configuration  
  - Add new disk  
  - Add or remove device  
  - Advanced  
  - Change CPU count  
  - Change resource  
  - Configure ManagedBy  
  - Memory  
  - Modify device settings  
  - Remove disk  
  - Rename  
  - Settings  
  - Swap file placement  
- Guest operations  
 - Guest Operations Modifications  
- Interaction  
 - Power on  
 - Power off  
 - Reset  
 - Suspend  
 - VMware Tools install  
- Inventory  
 - Create from existing  
 - Create new  
 - Move  
 - Register  
 - Remove  
 - Unregister  
- Provisioning  
 - Allow disk access  
 - Clone template  
 - Clone virtual machine  
 - Customize  
 - Deploy template  
 - Mark as virtual machine  
 - Read customization speceifications  

### Starting a new VM using the template

At this time (Feb 2016) there is a bug in the Vagrant vSphere plugin stopping it from communicating via WinRM to the new VM. However for our needs Vagrant is probably over kill anyway. We use the Hyper-V Powershell API (built into Windows 10) and the vSphere Powershel CLI:

- [vSphere Powershell CLI download](https://my.vmware.com/web/vmware/details?downloadGroup=VSP510-PCLI-510&productId=285)
- [vSphere Powershell CLI docs](https://www.vmware.com/support/developer/PowerCLI/PowerCLI51/html/index.html)

#### VMWare/vSphere 

	function SleepAndNotify($message, $minutes)
	{
	    Write-host $message -ForegroundColor Green
	
	    for ($i = 1;$i -le $minutes;$i++)
	    {
	        Sleep -Seconds 60
	
	        $remaining = $minutes - $i
	        Write-host "Waiting $remaining minutes..."
	    }
	}
	
	#=====================================================================================
	# Create and start a VMs and get its IP
	#=====================================================================================
	# To lookup names, use Get-Cluster, Get-Template, Get-folder etc - these return a list.
	$templateName = "Win2012R2Standard"
	
	$cluster = Get-Cluster -Name "YOUR_CLUSTER_NAME"
	$template = Get-Template -Name $templateName
	$datastore = Get-Datastore -Name "YOUR_DATASTORE"
	$resourcePool = Get-ResourcePool -Name "YOUR_RESOURCE_POOL_NAME"
	$folder = get-folder -Name "YOUR_FOLDER_NAME"
	
	Write-host "Creating VM from the $templateName template..." -ForegroundColor Green
	Connect-VIServer YOUR_VSPHERE_SERVER
	$vm = New-VM -Name $vmName -Template $template -ResourcePool $resourcePool -Datastore $datastore -Location $folder
	
	Write-host "Starting the VM..." -ForegroundColor Green
	Start-VM $vm
	
	SleepAndNotify "Waiting 3 minutes for an IP to appear..." 3
	
	$vm = Get-VM $vmName
	$ip = $vm.Guest.IPAddress[0]
	if (!$ip)
	{
		Write-host "No ip found for the VM, aborting." -ForegroundColor Yellow
		exit;
	}
	
	Write-Host "The IP of the VM is $ip"
	
	#=====================================================================================
	# Open up WinRM without encryption
	#=====================================================================================
	winrm quickconfig
	winrm set winrm/config/client/auth '@{Basic="true"}'
	winrm set winrm/config/client '@{AllowUnencrypted="true"}'
	Set-Item WSMan:\localhost\Client\TrustedHosts -Value "$ip" -Force
	
	#=====================================================================================
	# Connect to the server using WinRM
	#=====================================================================================
	$adminPassword = "changeme"
	$securePassword = convertto-securestring -AsPlainText -Force -String $adminPassword
	$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "administrator", $securePassword
	$session = new-pssession -computername $ip -credential $cred -Authentication Basic
	
	Write-host "Sys-preping the server (and rebooting)..." -ForegroundColor Green
	invoke-command -Session $session -ScriptBlock { C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /reboot /quiet /unattend:D:\Autounattend-sysprep.xml }

#### Hyper-V

	# Create and start a new VM
	new-vm -name "dev-desktop" -VHDPath "output-virtualbox-devdesktop\hyper-v-output\Virtual Hard Disks\disk.vhd"
	start-vm dev-desktop
	
#### AWS

	# Work in progress...
