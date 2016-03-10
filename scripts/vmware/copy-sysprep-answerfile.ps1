# Copy the answer file and sysprep helper functions to the D: drive, which
# can be called when a new VM is created from the template.
Copy-Item -Path A:\Autounattend-sysprep.xml -Destination D:\Autounattend-sysprep.xml