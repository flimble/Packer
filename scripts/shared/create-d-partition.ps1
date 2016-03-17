#################################################################################
# Create the D: volume, let it fill the the rest of the disk
#################################################################################
new-partition -DriveLetter D -DiskNumber 0 -UseMaximumSize
Format-Volume D -Confirm:$false -NewFileSystemLabel "Websites"