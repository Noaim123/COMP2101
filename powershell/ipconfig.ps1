# Getting network adapter configuration objects using Get-CimInstance command
$adapters = Get-CimInstance -Class Win32_NetworkAdapterConfiguration

# Using a pipeline with a a where-object filter on ipenabled property
$enabledAdapters = $adapters | Where-Object { $_.IPEnabled }

# Creating a custom object to store the relevant properties for each adapter
$adapterInfo = foreach ($adapter in $enabledAdapters) {
    [PSCustomObject]@{
        Description = $adapter.Description
        Index = $adapter.Index
        IPAddress = $adapter.IPAddress -join ', '
        SubnetMask = $adapter.IPSubnet -join ', '
        DNSDomain = $adapter.DNSDomain
        DNSServer = $adapter.DNSServerSearchOrder -join ', '
    }
}

# Using format-table command to format output clearly
$adapterInfo | Format-Table -Property Description, Index, IPAddress, SubnetMask, DNSDomain, DNSServer
