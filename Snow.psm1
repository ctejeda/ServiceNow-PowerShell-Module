
## Service Now API Function
## By Chris Tejeda 










Function Connect-ServiceNow {



$global:servicenowurl = Read-Host "Enter or paste your Service Now URL"


$Global:sysuser = "$servicenowurl/api/now/table/sys_user"
$Global:importset = "$servicenowurl/api/now/import/u_bluecherryou_import/0ba1c171132b8300811338b2f244b0bd"
$Global:incident = "$servicenowurl/api/now/table/incident"
$Global:Users = "$servicenowurl/api/now/table/sys_user"


### Authenticate to ServiceNow
$username = Read-Host "Enter ServiceNow UserName"
$uname = $username
$pass = Read-Host -AsSecureString "Enter Password"
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass)
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
$authorization = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("${username}:${password}"))
$Global:headers = @{ Authorization = "Basic $authorization" } 
if ( $username = Invoke-RestMethod -Method GET -Uri $Users -Headers $headers -ContentType "application/json" | select -ExpandProperty result | ? {$_.user_name -eq "$uname"} | select -ExpandProperty user_name ) 
{Write-Host "Authenticated User $username successfully to ServiceNow"}
else {Write-Host "User $username was not found";exit}
$Global:CurrentUserID = Invoke-RestMethod -Method GET -Uri $sysuser -Headers $headers -ContentType "application/json" | select -ExpandProperty result | ? {$_.user_name -eq "$uname"} | select -ExpandProperty sys_id 
 
}






Function Get-SNOWIncident {



param(



    [switch] $ShowALLMyOpen, ## this switch shows only the logged in users ticktes command
    [switch] $ShowMyResolved, ## Shows All Resolved incidents for current user
    [switch] $ShowALLOpen, 
    [switch] $ShowALL,
    [parameter(Mandatory=$false,Position=0,ValueFromPipeline=$true)] 
    [string]$IncidentNumber


    

     )


     if($ShowAllMyOpen){ Invoke-RestMethod -Method GET -Uri $incident -Headers $headers -ContentType "application/json" | select -ExpandProperty result | ? {$_.assigned_to -match "$CurrentUserID"} | ? {$_.state -ne "7"} | ? {$_.state -ne "8"} | ? {$_.state -ne "6"} |   select number ,short_description,description  }
     elseif ($ShowALLOpen) {Invoke-RestMethod -Method GET -Uri $incident -Headers $headers -ContentType "application/json" | select -ExpandProperty result | ? {$_.state -ne "7"} | ? {$_.state -ne "8"} | ? {$_.state -ne "6"} | select number ,short_description,description }
     elseif ($ShowALL) {Invoke-RestMethod -Method GET -Uri $incident -Headers $headers -ContentType "application/json" | select -ExpandProperty result | select number ,short_description,description }
     elseif ($IncidentNumber) {Invoke-RestMethod -Method GET -Uri $incident -Headers $headers -ContentType "application/json" | select -ExpandProperty result | ? {$_.number -eq "$IncidentNumber"} }
     elseif ($ShowMyResolved){Invoke-RestMethod -Method GET -Uri $incident -Headers $headers -ContentType "application/json" | select -ExpandProperty result | ? {$_.assigned_to -match "$CurrentUserID"} |  ? {$_.state -eq "6"} | select number ,short_description,description }
     else {Invoke-RestMethod -Method GET -Uri $incident -Headers $headers -ContentType "application/json" | select -ExpandProperty result  } ## If there's no switch, this line is executed 
     




}

Function Set-SNOWIncident {


param(

[cmdletbinding()]

    [parameter(Mandatory=$false,Position=0,ValueFromPipeline=$true)] 
    [string]$CloseIncident,
    [switch]$OpenIncident,
    [parameter(Mandatory=$false,Position=0,ValueFromPipeline=$true)] 
    [string]$ResolveIncident


       

     )


     if ($ResolveIncident)   { 
     
     
     
     $ResolvedNotes = Read-Host "Closing Incident $ResolveIncident, Please Enter The Resolution Notes";
     $body =  @"
{   
    
    "close_code":"Solved (Permanently)","state":"7","caller_id":"$CurrentUserID","close_notes":"$ResolvedNotes"
} 
"@  ; $incidentid = Invoke-RestMethod -Method GET -Uri $incident -Headers $headers -ContentType "application/json" | select -ExpandProperty result | ? {$_.number -eq "$ResolveIncident"} | select -ExpandProperty sys_id; Invoke-RestMethod -Method PUT -Uri "$incident/$incidentid" -Headers $headers -Body $body -ContentType "application/json" 



 }
     elseif ($OpenIncident) {
 
 $ShortDescription = Read-host "Enter a Short Description";
 $comments = Read-Host "Enter Comments";
 $AssignToEmail = Read-Host "Enter Assigne Email";
if ($AssignToSys_ID = Invoke-RestMethod -Method GET -Uri $Users -Headers $headers -ContentType "application/json" | select -ExpandProperty result | ? {$_.user_name -eq "$AssignToEmail"} | select -ExpandProperty sys_id )
 {Write-Host "User Found"}
 else {Write-host "User Not Found";exit};

 $body = @"
  
  
  {
  
  
  "short_description":"$ShortDescription", "comments":"$comments", "assigned_to":"$AssignToSys_ID"
  
  
  
  }
"@ ; Invoke-RestMethod -Method POST -Uri "$incident" -Headers $headers -Body $body -ContentType "application/json" 
  
  
 
 
 
 
 
 
 
 
 }
     elseif ($CloseIncident) {    $body =  @"
{   
    
    "close_code":"Solved (Permanently)","state":"7","caller_id":"$CurrentUserID","close_notes":"Closed"
} 
"@ ; $incidentid = Invoke-RestMethod -Method GET -Uri $incident -Headers $headers -ContentType "application/json" | select -ExpandProperty result | ? {$_.number -eq "$CloseIncident"} | select -ExpandProperty sys_id; Invoke-RestMethod -Method PUT -Uri "$incident/$incidentid" -Headers $headers -Body $body -ContentType "application/json"           }
     else {Write-Error "Missing Switch or Paramter"}



}












