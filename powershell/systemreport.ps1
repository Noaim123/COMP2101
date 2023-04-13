param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)
function Get-SystemHardwareInfo {
    if ($System) {
        $system = Get-WmiObject -Class Win32_ComputerSystem
        Write-Host "System Hardware Information"
        Write-Host "Manufacturer: $($system.Manufacturer)"
        Write-Host "Model: $($system.Model)"
        Write-Host "Serial Number: $($system.SerialNumber)"
        Write-Host "Chassis Type: $($system.ChassisTypes)"
        Write-Host ""
    }
}
if ($System) {
    Get-SystemHardwareInfo
    Get-OperatingSystemInfo
    Get-ProcessorInfo
    Get-RAMInfo
}
if ($Disks) {
    Get-Disk
}
if ($Network) {
    Get-NetworkAdapterInfo
}
   
if (!$System -and !$Disks -and !$Network) {
    Get-SystemHardwareInfo
    Get-OperatingSystemInfo
    Get-ProcessorInfo
    Get-RAMInfo
    Get-Disk
    Get-NetworkAdapterInfo
}





