# Creates a new transformation release in Fresh and adds the tasks and timers
#Create Form
<#Add-Type -AssemblyName system.windows.forms
$ReleaseForm = New-Object System.Windows.Forms.Form 

#Define Size, Background ectt.. 
$ReleaseForm.ClientSize = '700,500' 
$ReleaseForm.Text = "Release Detials" 
$ReleaseForm.BackColor = "#ffffff" 

#Add Inputs For user details
$Title1 = New-Object System.Windows.Forms.Label 
$Title1.Text = "User Details" 
$Title1.AutoSize = $true 
$Title1.Location = New-Object System.Drawing.Point(300,20) 
$Title1.Font = 'Microsoft Sans Serif,12'

$label1 = New-Object System.Windows.Forms.Label 
$label1.Text = 'API Key:' 
$label1.AutoSize = $true 
$label1.Location = New-Object System.Drawing.Point(20,50) 
$label1.Font = 'Microsoft Sans Serif,10'

$Textbox1 = New-Object System.Windows.Forms.TextBox 
$Textbox1.Left = 150 
$Textbox1.Top = 10
$Textbox1.Width = 200
$Textbox1.Location = New-Object System.Drawing.Point(120,50) 

$label2 = New-Object System.Windows.Forms.Label 
$label2.Text = 'Email Address:' 
$label2.AutoSize = $true 
$label2.Location = New-Object System.Drawing.Point(20,80) 
$label2.Font = 'Microsoft Sans Serif,10'

$Textbox2 = New-Object System.Windows.Forms.TextBox 
$Textbox2.Left = 150 
$Textbox2.Top = 10
$Textbox2.Width = 200
$Textbox2.Location = New-Object System.Drawing.Point(120,80) 

#Add Inputs For Release Details
$Title2 = New-Object System.Windows.Forms.Label 
$Title2.Text = "Release Details" 
$Title2.AutoSize = $true 
$Title2.Location = New-Object System.Drawing.Point(300,120) 
$Title2.Font = 'Microsoft Sans Serif,12'

$label3 = New-Object System.Windows.Forms.Label 
$label3.Text = 'Release Subject:' 
$label3.AutoSize = $true 
$label3.Location = New-Object System.Drawing.Point(20,150) 
$label3.Font = 'Microsoft Sans Serif,10'

$Textbox3 = New-Object System.Windows.Forms.TextBox 
$Textbox3.Left = 150 
$Textbox3.Top = 10
$Textbox3.Width = 270
$Textbox3.Location = New-Object System.Drawing.Point(160,150) 

$label4 = New-Object System.Windows.Forms.Label 
$label4.Text = 'Delivery Team:' 
$label4.AutoSize = $true 
$label4.Location = New-Object System.Drawing.Point(20,180) 
$label4.Font = 'Microsoft Sans Serif,10'

$ListBox = New-object System.Windows.Forms.ListBox
$ListBox.Location = New-Object System.Drawing.Point (160,180) 
$ListBox.Size = New-Object System.Drawing.Size (80,80) 
$ListBox.Height = 60 

$ListBox.Items.add('Transformation') 
$ListBox.Items.add('Client Solutions') 
$ListBox.Items.add('Finance') 

$label5 = New-Object System.Windows.Forms.Label 
$label5.Text = 'Enter Release Date (YYYY-MM-DD):' 
$label5.AutoSize = $true 
$label5.Location = New-Object System.Drawing.Point(20,250) 
$label5.Font = 'Microsoft Sans Serif,10'

$Textbox4 = New-Object System.Windows.Forms.TextBox 
$Textbox4.Left = 150 
$Textbox4.Top = 10
$Textbox4.Width = 100
$Textbox4.Location = New-Object System.Drawing.Point(280,250) 

$label6 = New-Object System.Windows.Forms.Label 
$label6.Text = 'Release Type' 
$label6.AutoSize = $true 
$label6.Location = New-Object System.Drawing.Point(20,300) 
$label6.Font = 'Microsoft Sans Serif,10'

$ListBox2 = New-object System.Windows.Forms.ListBox
$ListBox2.Location = New-Object System.Drawing.Point (160,300) 
$ListBox2.Size = New-Object System.Drawing.Size (80,80) 
$ListBox2.Height = 60 

$ListBox2.Items.Add('Standard') 
$ListBox2.Items.Add('Emergency') 


#Add Ok Button
$Button1 = New-Object System.Windows.Forms.Button 
$Button1.Location = New-Object System.Drawing.Point (600,400) 
$Button1.Size = New-Object System.Drawing.Size (60,40) 
$Button1.Text = 'Submit'

$eventHandler = [System.EventHandler]{
$textBox1.Text;
$releaseform.Close();};
$button1.Add_Click($eventHandler)

$ReleaseForm.Controls.AddRange(@($Title1,$Title2,$label1,$label2,$label3,$label4,$label5,$label6,$Textbox1,$Textbox2,$textbox3,$textbox4,$ListBox,$ListBox2,$Button1))
[void]$ReleaseForm.ShowDialog() #>

#Get values from form (alter if not usng form) 
$APIKey = 'FXqtfB8u9PfjO2qtmpT'
$APIKey2 = 'NiBPAoLv1WjL2VSkI8bj'
$Email = 'adrians@cccs.co.uk'
$Subject = 'Test 3'
$deliveryteam = 'Transformation'
$StartTimeTemp = '2020-11-10'
$releasetype = 'standard'

if($releasetype -eq 'Standard') { 
$RelTypeID = 2 } 
elseif ($releasetype -eq 'Emergency'){ 
$RelTypeID = 4 }

# Create Encoded Authorization for Fresh Service API

$EncodedCredentials = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $APIKey,$null)))
$HTTPHeaders = @{}
$HTTPHeaders.Add('Authorization', ("Basic {0}" -f $EncodedCredentials))
$HTTPHeaders.Add('Content-Type', 'application/json')

$EncodedCredentialsAdmin = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $APIKey2,$null)))
$HTTPHeadersAdmin = @{}
$HTTPHeadersadmin.Add('Authorization', ("Basic {0}" -f $EncodedCredentialsAdmin))
$HTTPHeadersadmin.Add('Content-Type', 'application/json')

$StartTime = get-date $StartTimeTemp -Format s -Hour 7 
$EndTime = get-date $StartTimeTemp -Format s -Hour 18 

# Create Release
    #Create Release Object
$ReleasePost = [PSCustomObject]@{ 
release_type = $RelTypeID 
status = 1 
subject = $Subject 
priority = 1 
planned_start_date = $StartTime
planned_end_date = $EndTime
custom_fields =  @{"delivery_team" = $deliveryteam} 
}
#Convert to Json and Post to API
$ReleaseJson = $ReleasePost | ConvertTo-Json
$ReleaseURL = "https://stepchange.freshservice.com/api/v2/releases"
$Release = Invoke-RestMethod -Method Post -Uri $ReleaseURL -body $releaseJson -Headers $httpheaders

#Add Description to Release?? (Not sure if this is possible, raised ticket with FreshService) 

#Get Users Agent ID
$AgentURL = "https://stepchange.freshservice.com/api/v2/agents?email=$($email)"
$Agent = Invoke-RestMethod -Method Get -Uri $agentURL -Headers $httpheadersadmin


#Add Tasks & Timers to Release
    #Create Task Names
If ($deliveryteam -eq 'Transformation') {
$TaskNames = @( "Deployments" , "Misc" , "Live Verification" , "Restarts" , "LSA Tasks" , "SnapShots" , "Holding Pages and Dail" )} 
elseif ($deliveryteam -eq 'Client Solutions' -or 'Finance' ){ 
$TaskNames =@("Deployments" , "Live Verification" , "Misc") } 

    #Create Task URL's
$TaskURL = "https://stepchange.freshservice.com/api/v2/releases/$($Release.release.id)/tasks"
$TimerURL ="https://stepchange.freshservice.com/api/v2/releases/$($Release.release.id)/time_entries"

    #Create Task & Timer Objects
Foreach ($name in $TaskNames){
$TaskPost =@{} 
$TaskPost.Add("title" , "$name")  
    #Convert to Json and Post to API
$TaskJson = $TaskPost | ConvertTo-Json 
$task = Invoke-RestMethod -Method Post -Uri $TaskURL -body $TaskJson -Headers $httpheaders

$TimerPost = @{} 
$TimerPost.Add("note" , "$name")
$TimerPost.Add("time_spent" , "00:00")
$TimerPost.Add("agent_id" , $($agent.agents.id))
$TimerPost.Add("task_id" , $($Task.task.id))
$TimerJson = $TimerPost | ConvertTo-Json
$timer = Invoke-RestMethod -Method Post -URI $TimerURL -Body $TimerJson -Headers $HTTPHeaders
}

