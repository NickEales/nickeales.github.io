<#
Disclaimer: The sample scripts are not supported under any Microsoft standard support program or service. 
The sample scripts are provided AS IS without warranty of any kind. Microsoft further disclaims all implied 
warranties including, without limitation, any implied warranties of merchantability or of fitness for a 
particular purpose. The entire risk arising out of the use or performance of the sample scripts and 
documentation remains with you. In no event shall Microsoft, its authors, or anyone else involved in the 
creation, production, or delivery of the scripts be liable for any damages whatsoever (including, without 
limitation, damages for loss of business profits, business interruption, loss of business information, or 
other pecuniary loss) arising out of the use of or inability to use the sample scripts or documentation, 
even if Microsoft has been advised of the possibility of such damages. 
#>

param(
    [string]$ResourceID,    #subscription ID of recovery services vault
    [object]$AuthorizationToken,
    [int]$HoursAgo=48
)

$Headers = @{}
$Headers.Add("Authorization","$($AuthorizationToken.token_type) "+ " " + "$($AuthorizationToken.access_token)")
$ResourceID = $ResourceID.trim('/')

write-host "get backup jobs over last $HoursAgo hours:"
$startTime=get-date $(get-date).touniversaltime().addHours(0-$HoursAgo) -uFormat "%Y-%m-%d %r" 
$endTime=get-date $(get-date).touniversaltime() -uFormat "%Y-%m-%d %r" 
$oDatafilter = "operation eq 'Backup' and startTime eq '$startTime' and endTime eq '$endTime'"  
write-host $oDatafilter
$UrlEncodedoDataFilter = [System.Web.HttpUtility]::UrlEncode($oDatafilter) 

#Using example found here: https://docs.microsoft.com/en-us/rest/api/backup/backupjobs/list
$RestApiURL = "https://management.azure.com/$($ResourceID)/backupJobs?api-version=2017-07-01&`$filter=$UrlEncodedoDataFilter"
write-host "RestApiURL = $RestApiURL"

$ApiResponse = Invoke-RestMethod -Method Get -Uri $RestApiURL -Headers $Headers
#uncomment the folowing line to see more possible outputs instead of what I have filtered to
#$ApiResponse | ConvertTo-Json -Depth 3 | Write-host
$ApiResponse.value.properties | ft backupManagementType,entityFriendlyName,operation,status,startTime,endTime
