$env:path += ";$home/documents/github/comp2101/powershell"
$env:path += ";$home/documents/github/comp2101/powershell"
function welcome {
    Write-Host "Welcome to PowerShell!"
    Write-Host "This is your custom welcome message from the profile script."
    Write-Host "You can customize this message as you like!"
}
function get-mydisks {
    $disks = Get-PhysicalDisk
    $diskInfo = $disks | Select-Object Manufacturer, Model, SerialNumber, FirmwareRevision, Size
    $diskInfo | Format-Table
}