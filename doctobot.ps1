Set-TimeZone -Name 'Romance Standard Time' -PassThru
#$date = Get-Date -Format "yyyy-MM-dd"
$date = "2023-07-04"
$visit_motive_ids = "6313020"
$agenda_ids = "931268"
$practice_ids = "312173"


# download json
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")
$ie = New-Object -ComObject 'internetExplorer.Application'
$ie.Visible= $true # Make it visible

$ie.Navigate("https://www.doctolib.fr/availabilities.json?start_date=$date&visit_motive_ids=$visit_motive_ids&agenda_ids=$agenda_ids&insurance_sector=public&practice_ids=$practice_ids")
While ($ie.Busy -eq $true) {Start-Sleep -Seconds 3;}

#$app = Get-Process | ?{$_.MainWindowHandle -eq $ie.hwnd}
#[Microsoft.VisualBasic.Interaction]::AppActivate($app.Id)
#Start-Sleep -Seconds 2;
[System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

### LOCATE DOWNLOAD FOLDER
$adress = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
Move-Item -Path "$adress/availabilities.json" -Destination "." -force

#Invoke-WebRequest -Uri "https://www.doctolib.fr/availabilities.json?start_date=$date&visit_motive_ids=$visit_motive_ids&agenda_ids=$agenda_ids&insurance_sector=public&practice_ids=$practice_ids" -OutFile "./download.json"

$slot = Get-Content "./availabilities.json" -Encoding UTF8 | ConvertFrom-Json
$nextslot = $slot.next_slot
$rdv = $slot.slots
$message = $slot.message

if ( $nextslot -eq $null ) { 
echo "Pas de nouveau rdv possible... $message $slot"
#$tmtext = "Pas de nouveau rdv possible... | $message | $rdv"
#$tmtoken = "$env:TELEGRAM"
#$tmchatid = "$env:CHAT_ID"
#Invoke-RestMethod -Uri "https://api.telegram.org/bot$tmtoken/sendMessage?chat_id=$tmchatid&text=$tmtext"

} else { 

$tmtext = "Nouveau rendez-vous possible ! $nextslot | $rdv"
$tmtoken = "$env:TELEGRAM"
$tmchatid = "$env:CHAT_ID"
Invoke-RestMethod -Uri "https://api.telegram.org/bot$tmtoken/sendMessage?chat_id=$tmchatid&text=$tmtext"

}
