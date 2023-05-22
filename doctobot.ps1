$date = Get-Date -Format "yyyy-MM-dd"
$visit_motive_ids = "6313020"
$agenda_ids = "931268"
$practice_ids = "312173"

# download json
Invoke-WebRequest -Uri "https://www.doctolib.fr/availabilities.json?start_date=$date&visit_motive_ids=$visit_motive_ids&agenda_ids=$agenda_ids&insurance_sector=public&practice_ids=$practice_ids" -OutFile "./download.json"
$slot = Get-Content "./download.json" -Encoding UTF8 | ConvertFrom-Json
$nextslot = $slot.next_slot

if ( $nextslot -eq $null ) { 
echo "Pas de nouveau rdv possible..."

} else { 

$tmtext = "Nouveau rendez-vous possible ! $nextslot"
$tmtoken = "$env:TELEGRAM"
$tmchatid = "$env:CHAT_ID"
Invoke-RestMethod -Uri "https://api.telegram.org/bot$tmtoken/sendMessage?chat_id=$tmchatid&text=$tmtext"

}
