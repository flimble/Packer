#################################################################################
# Check for a DVD drive and change its drive letter
#################################################################################
$dvdDrive = Get-WmiObject win32_volume -filter DriveType=5
if ($dvdDrive -and $dvdDrive.DriveLetter -eq "D:")
{
    $dvdDrive.DriveLetter = "G:"
    $dvdDrive.Put()
}

#################################################################################
# Create the D: volume, let it fill the the rest of the disk
#################################################################################
new-partition -DriveLetter D -DiskNumber 0 -UseMaximumSize
Format-Volume D -Confirm:$false -NewFileSystemLabel "Websites"