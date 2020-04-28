$SourceFile = 'https://download.lenovo.com/pccbbs/thinkvantage_en/system_update_5.07.0095.exe'
$Outfile = "$ENV:USERPROFILE" + "\Desktop\Lenovo Driver Update Utility.exe"


#Download the installer file
Invoke-WebRequest -URI $SourceFile -OutFile $outfile

#Install Silently
Start-Process $Outfile -ArgumentList '/VERYSILENT' -Verb RunAs -Wait

Pause