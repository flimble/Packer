# Packer
This repository is a set of [Packer](packer.io) files for creating Windows 2012 R2 templates on VMWare/vSphere and Hyper-V (via VirtualBox).

### Pre-requisites

- en_windows_server_2012_r2_with_update_x64_dvd_6052708.iso from MSDN/Technet
- VirtualBox or VMWare Professional or both.

### Conventions/folder structure

- `.json` file - contains 4 Packer definitions. There are 2 definitions per VM: 
 1. Creates the base Windows hard drive image and updates it.
 2. Takes the output from 1) and installs Windows features like IIS and software.
- `scripts` folder - contains Powershell scripts for the two stages. Windows updates are done via the answer file, as WinRM can't run Windows updates. The rest is done via WinRM in Packer.
- `answerfiles` This contains the Windows answer file that Windows needs for automated setups. It contains a default user "packer/packer" and volume licence keys from Microsoft KMS.

#### vSphere 

The vSphere Packer builder section of the json file is for creating servers, usually web servers.

#### VirtualBox

The VirtualBox Packer builder definition of the json file is for creating a developer desktop, it is converted from VirtualBox to HyperV for performance benefits (that are negligible according to some, massive according to others).

### Getting started

Make sure the MSDN Windows 2012 R2 ISO is in the /iso/ folder ("en_windows_server_2012_r2_with_update_x64_dvd_6052708.iso"), and then 
run build-web.ps1 in a new powershell prompt.

### The story of the Packer journey

:gun: :gun: :gun: :gun: :gun:
There have been quite a few hicups, learnings and annoyances on the way:

- OVFtool.exe has some bad error messages
- Vagrant's vSPhere plugin is broken (see below)
- VMWare tools doesn't appear to install when done via Packer, it hangs (Windows 10).
- VMWare tools on the VMWare site only has the latest version, killing scripts relying on older-versions.
- You only need to use Boxstarter for older Windows Servers (< 2012)
- Sysprep, the SID gift that keeps on giving.
- OpenSSH isn't necessary, plus there is a Microsoft implementation now (but it doesn't work with Vagrant).
- You shall not get an updated (official) Win2012 Server ISO, you have to spend an hour in Windows Update every time.


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

### Pushing the VMX file into vSphere and marking it as a template

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


#### VSphere Permissions

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

### Starting a new vSphere VM from the template

At this time (Feb 2016) there is a bug in the Vagrant vSphere plugin stopping it from communicating via WinRM to the new VM.

The hacky answer is to use the vSphere Powershell CLI:

- [Powershell CLI download](https://my.vmware.com/web/vmware/details?downloadGroup=VSP510-PCLI-510&productId=285)
- [vSphere Powershell CLI docs](https://www.vmware.com/support/developer/PowerCLI/PowerCLI51/html/index.html)

The commands are straight forward:

	# Work in progress...

You will also need your VM to join its domain, sysprep it, and then rename the computer, finally disabling openssh and winRM.
The easiest option is to SSH into the box (as WinRM is a huge PITA), using the Microsoft OpenSSH service that is running.

The sysprep answer file is already on your D: drive, and also a set of functions that you can call via two Putty scripts (waiting
for the restart before calling the 2nd script):

	REM Microsoft OpenSSH currently only works with the command prompt
	powershell -Command "&{ . C:\Code\Packer\scripts\shared\sysprep.ps1;Join-Domain 'domain', 'admin', 'password';Invoke-SysPrep }"

	REM After the restart...
	powershell -Command "&{ Rename-Computer -NewName 'My-Server' }"


Of course some of this is doing the job of Vagrant: polling for the SSH server to re-appear is something Vagrant has inbuilt. This is only 
because of the Vagrant vSphere Plugin issue. Once this is fixed (in 0.8.2 hopefully) then none of these steps will be necessary as 
Vagrant will create the VM and run the provisioner for you.
