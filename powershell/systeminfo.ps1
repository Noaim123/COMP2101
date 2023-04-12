﻿# Retrieve system hardware description
$computerSystem = Get-CimInstance -ClassName win32_computersystem

# Retrieve operating system name and version number
$operatingSystem = Get-CimInstance -ClassName win32_operatingsystem

# Retrieve processor description, speed, number of cores, and cache sizes
$processors = Get-CimInstance -ClassName win32_processor

# Retrieve summary of installed RAM
$physicalMemory = Get-CimInstance -ClassName win32_physicalmemory

# Retrieve physical disk drives and their logical disks
$diskDrives = Get-CimInstance -ClassName win32_diskdrive
$diskPartitions = $diskDrives | Get-CimAssociatedInstance -ResultClassName CIM_diskpartition
$logicalDisks = $diskPartitions | Get-CimAssociatedInstance -ResultClassName CIM_logicaldisk

# Create a table for RAM summary
$ramSummary = @()
foreach ($memory in $physicalMemory) {
    $ramSummary += [PSCustomObject]@{
        Vendor = $memory.Manufacturer
        Description = $memory.Description
        Size = $memory.Capacity / 1GB
        Bank = $memory.BankLabel
        Slot = $memory.DeviceLocator
    }
}

# Create a table for disk drive and logical disk information
$diskInfo = @()
foreach ($disk in $diskDrives) {
    $partitions = $disk | Get-CimAssociatedInstance -ResultClassName CIM_diskpartition
    foreach ($partition in $partitions) {
        $logicalDisks = $partition | Get-CimAssociatedInstance -ResultClassName CIM_logicaldisk
        foreach ($logicalDisk in $logicalDisks) {
            $diskInfo += [PSCustomObject]@{
                Vendor = $disk.Manufacturer
                Model = $disk.Model
                Size = $disk.Size / 1GB
                Drive = $logicalDisk.DeviceID
                "Free Space(GB)" = $logicalDisk.FreeSpace / 1GB
                "Size(GB)" = $logicalDisk.Size / 1GB
                "Free Space(%)" = [math]::Round(($logicalDisk.FreeSpace / $logicalDisk.Size) * 100, 2)
            }
        }
    }
}

# Output the system information
Write-Host "System Hardware Description:"
$computerSystem | Format-Table -Property Manufacturer, Model, Name, NumberOfProcessors, NumberOfLogicalProcessors

Write-Host "`nOperating System Name and Version Number:"
$operatingSystem | Format-Table -Property Caption, Version

Write-Host "`nProcessor Description, Speed, Number of Cores, and Cache Sizes:"
$processors | Format-Table -Property Name, Description, MaxClockSpeed, NumberOfCores, L2CacheSize, L3CacheSize

Write-Host "`nSummary of Installed RAM:"
$ramSummary | Format-Table -Property Vendor, Description, Size, Bank, Slot
$totalRAM = [math]::Round(($physicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 2)
Write-Host "Total RAM Installed: $totalRAM GB"

Write-Host "`nSummary of Physical Disk Drives and Logical Disks:"
$diskInfo | Format-Table -Property Vendor, Model, Size, Drive, "Free Space(GB)", "Size(GB)", "Free Space(%)"

# Function to retrieve video card information
Function Get-VideoCardInfo {
    $videoControllers = Get-CimInstance -ClassName win32_videocontroller
    $videoCardInfo = @()
    foreach ($videoController in $videoControllers) {
        $resolution = "{0} x {1}" -f $videoController.CurrentHorizontalResolution, $videoController.CurrentVerticalResolution
        $videoCardInfo += [PSCustomObject]@{
            Vendor = $videoController.VideoProcessor
            Description = $videoController.Description
            Resolution = $resolution
        }
    }
    return $videoCardInfo
}

# Call the function to get video card information
$videoCardInfo = Get-VideoCardInfo

# Output the video card information in the desired format
Write-Host "Video Card Information"
Write-Host "-----------------------"
foreach ($videoCard in $videoCardInfo) {
    Write-Host "Vendor: $($videoCard.Vendor)"
    Write-Host "Description: $($videoCard.Description)"
    Write-Host "Resolution: $($videoCard.Resolution)"
    Write-Host "-----------------------"
}