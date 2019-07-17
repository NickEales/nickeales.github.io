$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
& "$PSScriptRoot\AzureRSVRestApiExample.ps1" `
    -subscriptionId '99998888-7777-6666-a564-98a43783608e' `
    -TenantId '00001111-2222-3333-94c0-25df1220b4f4' `
    -clientId "c3dce98a-9999-1111-0000-6127fd99160e" `
    -ClientSecret "J=B1Q8=E5_6<brokensecret>75" `
    -resourceGroupName 'testRsvApi' `
    -VaultName 'testrsvapivault'
