Set-Location "$PSScriptRoot"
$Computers = get-content ".\computers.txt"

$Computers | ForEach-Object {
Get-NetConnectionProfile | Select-Object -ExpandProperty Name
}
