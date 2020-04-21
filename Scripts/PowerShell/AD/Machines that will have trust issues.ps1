$logonDate = (Get-Date).AddDays(-180)

Get-ADComputer -Filter { (Enabled -eq $true) -and (PasswordLastSet -lt $logonDate ) } -Properties Name, OperatingSystemVersion, PasswordLastSet | Select-Object Name, OperatingSystemVersion, PasswordLastSet | Sort-Object PasswordLastSet -Descending |