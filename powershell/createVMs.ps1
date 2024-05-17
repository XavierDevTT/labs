# Set the execution policy to bypass
Set-ExecutionPolicy Bypass

# Define virtual machine configurations
$vmConfigurations = @(
    @{ Name = "play-ansible"; Cores = 2; Memory = 2GB; VHDSize = 30GB; VmDir = "C:\path/to/directory" },
    @{ Name = "play-ca-01"; Cores = 2; Memory = 2GB; VHDSize = 10GB; VmDir = "C:\path/to/directory" },
    @{ Name = "play-cs-01"; Cores = 2; Memory = 4GB; VHDSize = 40GB; VmDir = "C:\path/to/directory" },
    @{ Name = "play-ss-01"; Cores = 4; Memory = 6GB; VHDSize = 40GB; VmDir = "C:\path/to/directory" },
    @{ Name = "play-misp-01"; Cores = 4; Memory = 6GB; VHDSize = 40GB; VmDir = "C:\path/to/directory" },
    @{ Name = "play-ss-02"; Cores = 4; Memory = 6GB; VHDSize = 40GB; VmDir = "C:\path/to/directory" },
    @{ Name = "play-is-01"; Cores = 2; Memory = 4GB; VHDSize = 40GB; VmDir = "C:\path/to/directory" }

    # Add more configurations as needed
)

# Loop through each virtual machine configuration
foreach ($config in $vmConfigurations) {
    # Define variables
    $vmName = $config.Name
    $vmPath = $config.VmDir
    $MemoryStartupBytes = $config.Memory
    $NewVHDSizeBytes = $config.VHDSize
    $cpuCount = $config.Cores
    $vlanID = 9
    $generation_number = 1

    # Create a new virtual machine
    New-VM -Name $vmName -Path $vmPath -MemoryStartupBytes $MemoryStartupBytes -Generation $generation_number -NewVHDPath $vmPath\$vmName\$vmName"_OS.vhdx" -NewVHDSizeBytes $NewVHDSizeBytes -SwitchName "Production" 

    # Add Vlan ID
    Set-VMNetworkAdapterVlan -VMName $vmName -Access -VlanId $vlanID

    # Set Processor Count
    Set-VMProcessor -VMName "$vmName" -Count $cpuCount
}

# Set virtual machine to automatically start
# Set-VM -Name $vmName -AutomaticStartAction Start -AutomaticStartDelay 120

# Add virtual machine to failover cluster
# Add-ClusterVirtualMachineRole -VMName $vmName -Cluster $clusterName -Name $vmName 

# Add virtual machine to a specific node
# Move-ClusterVirtualMachineRole -Name $vmName -Node $nodeName
