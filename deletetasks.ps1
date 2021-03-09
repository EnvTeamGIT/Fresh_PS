$apikey = 'NiBPAoLv1WjL2VSkI8bj'
$EncodedCredentials = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $APIKey,$null)))
$HTTPHeaders = @{}
$HTTPHeaders.Add('Authorization', ("Basic {0}" -f $EncodedCredentials))
$HTTPHeaders.Add('Content-Type', 'application/json')

$TimerURL ="https://stepchange.freshservice.com/api/v2/releases/39/tasks"

$rel39 = Invoke-restmethod -Method Get -Uri $timerURL -Headers $HTTPHeaders

$tIDs = $rel39.tasks.id

foreach ($id in $tids){

invoke-restmethod -Method Delete -uri "https://stepchange.freshservice.com/api/v2/releases/39/tasks/$id" -Headers $HTTPHeaders}

#Test Changes