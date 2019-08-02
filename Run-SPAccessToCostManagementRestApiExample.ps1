$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
& "$PSScriptRoot\Run-GetSPTokenAndRunScript.ps1" `
    -ScriptToCall "$PSScriptRoot\AzureCostManagementRestApiExample.ps1" `
    -TenantId '61b9f171-e805-4312-94c0-25df1220b4f4' `
    -clientId 'a0f5ec63-9951-4691-8c35-6d6284cb29b4' `
    -ClientSecret  '=OUUx4P?8.=dvaDvr5IxILTjzzvI2:q_'
