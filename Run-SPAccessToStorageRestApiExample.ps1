$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
& "$PSScriptRoot\Run-GetSPTokenAndRunScript.ps1" `
    -scriptToCall "$PSScriptRoot\AzureRSVRestApiExample.ps1" `
    -subscriptionId '99998888-7777-6666-a564-98a43783608e' `
    -TenantId '61b9f171-e805-4312-94c0-25df1220b4f4' `
    -clientId 'a0f5ec63-9951-4691-8c35-6d6284cb29b4' `
    -ClientSecret  '=OUUx4P?8.=dvaDvr5IxILTjzzvI2:q_' `
    -ScriptParam @{TenantId = '61b9f171-e805-4312-94c0-25df1220b4f4'}
