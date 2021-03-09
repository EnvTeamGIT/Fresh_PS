$apikey = 'NiBPAoLv1WjL2VSkI8bj'
$EncodedCredentials = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $APIKey,$null)))
$HTTPHeaders = @{}
$HTTPHeaders.Add('Authorization', ("Basic {0}" -f $EncodedCredentials))
$HTTPHeaders.Add('Content-Type', 'application/json')

#Get Users Agent ID
$AgentURL = "https://stepchange.freshservice.com/api/v2/agents?email=seang@cccs.co.uk"
$Agent = Invoke-RestMethod -Method Get -Uri $AgentURL -Headers $HTTPHeaders

$releasenum = '58'


    foreach ($num in $Releasenum){
    $releaseurl = "https://stepchange.freshservice.com/api/v2/releases/$num"
$TaskURL = "https://stepchange.freshservice.com/api/v2/releases/$($num)/tasks"
$TimerURL ="https://stepchange.freshservice.com/api/v2/releases/$($num)/time_entries"
$Release = Invoke-RestMethod -Method Get -Uri $releaseurl -Headers $HTTPHeaders 
$DeliveryTeam = $release.release.custom_fields.delivery_team
$releasedate = $release.release.work_start_date 
$DueDate = get-date $releasedate -Format s 




#Add Tasks & Timers to Release
    #Create Task Names
If ($deliveryteam -eq 'Transformation') {
$TaskNames = @( "Deployments" , "Misc" , "Live Verification" , "Restarts" , "LSA Tasks" , "SnapShots" , "Holding Pages and Dial" )} 
elseif ($deliveryteam -eq 'Client Solutions' -or 'Finance' ){ 
$TaskNames =@("Deployments" , "Live Verification" , "Misc") } 



    #Create Task & Timer Objects
Foreach ($name in $TaskNames){
$TaskPost =@{} 
$TaskPost.Add("title" , "$name")  
$TaskPost.Add("due_date", "$duedate")
    #Convert to Json and Post to API
$TaskJson = $TaskPost | ConvertTo-Json 
$Task = Invoke-RestMethod -Method Post -Uri $TaskURL -Body $TaskJson -Headers $HTTPHeaders

$TimerPost = @{} 
$TimerPost.Add("note" , "$name")
$TimerPost.Add("time_spent" , "00:00")
$TimerPost.Add("agent_id" , $($agent.agents.id))
$TimerPost.Add("task_id" , $($Task.task.id))
$TimerJson = $TimerPost | ConvertTo-Json
$Timer = Invoke-RestMethod -Method Post -URI $TimerURL -Body $TimerJson -Headers $HTTPHeaders
}
}
#Sean Graham