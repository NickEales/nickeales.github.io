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
    [string]$subscriptionId,    #subscription ID of recovery services vault
    [string]$TenantId,          #AAD Tenant ID
    [string]$clientId,          #ClientID is the Client ID from the App registration in AzureAD
    [string]$ClientSecret,      #ClientSecret is the secret from the App registration in Azure AD 
    [string]$resourceGroupName, #Recovery services Vault resource group name
    [string]$VaultName          #Recovery services Vault name
)

#Get Authorization token
$RequestAccessTokenUri = "https://login.microsoftonline.com/$TenantId/oauth2/token"
$Resource = "https://management.core.windows.net/"
$body = "grant_type=client_credentials&client_id=$ClientId&client_secret=$ClientSecret&resource=$Resource"
$Token = Invoke-RestMethod -Method Post -Uri $RequestAccessTokenUri -Body $body -ContentType 'application/x-www-form-urlencoded'

if($null -eq $Token){throw "token not obtained - exiting"}

$Headers = @{}
$Headers.Add("Authorization","$($Token.token_type) "+ " " + "$($Token.access_token)")

write-host "Get-RecoveryServicesVaults:"
$ApiURL = "https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.RecoveryServices/vaults/$($vaultName)?api-version=2016-06-01"
$ApiResponse = Invoke-RestMethod -Method Get -Uri $ApiURL -Headers $Headers
#uncomment the folowing line to see more possible outputs instead of what I have filtered to
#$ApiResponse | ConvertTo-Json -Depth 3 | Write-host
$ApiResponse  | ft name,location,type |out-string|write-host

write-host "Get-AzureRmRecoveryServicesBackupContainer:"
$ApiURL = "https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.RecoveryServices/vaults/$($vaultName)/backupProtectionContainers?%24filter=backupManagementType%20eq%20%27AzureIaasVM%27&api-version=2016-06-01"
$ApiResponse = Invoke-RestMethod -Method Get -Uri $ApiURL -Headers $Headers
#uncomment the folowing line to see more possible outputs instead of what I have filtered to
#$ApiResponse | ConvertTo-Json -Depth 3 | Write-host
$ApiResponse.value | ft name,type |out-string |write-host

write-host "Get-AzureRmRecoveryServicesBackupItem:"
$ApiURL = "https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.RecoveryServices/vaults/$($vaultName)/backupProtectedItems?api-version=2017-07-01"
$ApiResponse = Invoke-RestMethod -Method Get -Uri $ApiURL -Headers $Headers
#uncomment the folowing line to see more possible outputs instead of what I have filtered to
#$ApiResponse | ConvertTo-Json -Depth 3 | Write-host
$ApiResponse.value.properties | ft containerName,policyName,friendlyName,protectionStatus,lastBackupStatus,lastRecoveryPoint |out-string |write-host

write-host "Get-AzureRmRecoveryServicesBackupJob:"
$ApiURL = "https://management.azure.com/subscriptions/$($subscriptionId)/resourceGroups/$($resourceGroupName)/providers/Microsoft.RecoveryServices/vaults/$($vaultName)/backupJobs?api-version=2017-07-01"
$ApiResponse = Invoke-RestMethod -Method Get -Uri $ApiURL -Headers $Headers
#uncomment the folowing line to see more possible outputs instead of what I have filtered to
#$ApiResponse | ConvertTo-Json -Depth 3 | Write-host
$ApiResponse.value.properties | ft entityFriendlyName,operation,status,duration,startTime,endTime |out-string |write-host

