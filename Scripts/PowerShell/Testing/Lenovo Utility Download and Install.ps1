#Setting up the Variables
$SourceFile = 'https://download.lenovo.com/pccbbs/thinkvantage_en/system_update_5.07.0095.exe'
$Outfile = "$ENV:USERPROFILE" + "\Desktop\Lenovo Driver Update Utility.exe"

#Download the installer file
Invoke-WebRequest -URI $SourceFile -OutFile $Outfile

#Install Silently
Start-Process -FilePath $Outfile -Verb RunAs -ArgumentList '/VERYSILENT' -Verbose -Wait