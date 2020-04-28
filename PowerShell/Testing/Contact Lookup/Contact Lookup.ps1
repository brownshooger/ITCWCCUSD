$School = Read-Host "What School?"
$Position = Read-Host "What Position?"

get-aduser -Filter "Office -Like '*$School*' -and Title -Like '*$Position*'" -Properties Name, Office, telephoneNumber, ipPhone, Mail, title | Select Name, Office, telephoneNumber, ipPhone, Mail, title | Sort Name