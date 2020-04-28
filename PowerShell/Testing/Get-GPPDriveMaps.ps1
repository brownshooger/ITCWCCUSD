Set-Location $PSScriptRoot
$GPO = Get-GPO -All

foreach ($Policy in $GPO) {

    $GPOID = $Policy.Id
    $GPODom = $Policy.DomainName
    $GPODisp = $Policy.DisplayName

    if (Test-Path "\\$($GPODom)\SYSVOL\$($GPODom)\Policies\{$($GPOID)}\User\Preferences\Drives\Drives.xml")
    {
    [xml]$DriveXML = Get-Content "\\$($GPODom)\SYSVOL\$($GPODom)\Policies\{$($GPOID)}\User\Preferences\Drives\Drives.xml"

    foreach ( $drivemap in $DriveXML.Drives.Drive ) {

    $Output =[PSCustomObject] @{
        GPOName = $GPODisp
        DriveLetter = $drivemap.Properties.Letter + ":"
        DrivePath = $drivemap.Properties.Path
        DriveLabel = $drivemap.Properties.label
        DriveFilterGroup = $drivemap.Filters.FilterGroup.Name
        }
        $Output | Export-Csv ".\List Of Group Drive Mappings.csv" -Append
        }
    }
}