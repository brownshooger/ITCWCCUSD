########## Setup Variables for Script & Remove Spaces from text file ##########

Set-Location $PSScriptRoot
$Computers = Get-Content .\~ComputerList.txt

########## Cleanup Text File with List of PCs ##########

(Get-Content .\~ComputerList.txt) | ForEach-Object { $_.TrimEnd() } | Where-Object { $_ -ne "" } | Set-Content .\~ComputerList.txt

########## Test if the Computer is online ##########

$OnlineComputers = New-Object System.Collections.Generic.List[System.Object]

foreach ($Computer in $Computers) {

    if (test-connection $Computer -count 1 -quiet) {
        Write-Host "$Computer is Online" -ForegroundColor Black -BackgroundColor Green
        $OnlineComputers.Add($Computer)
    }

    else {
        Write-Host "$Computer is Offline" -ForegroundColor Black -BackgroundColor Red
        $OfflineComputers = New-Object PSObject -Property @{
            ComputerName = $Computer
            Status       = "Offline"
        }
        $OfflineComputers | Export-Csv .\~Failed.csv -NoTypeInformation -Force -Append
    }
}