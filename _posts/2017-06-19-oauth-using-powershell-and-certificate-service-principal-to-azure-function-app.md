---
id: 225
title: OAuth using PowerShell and certificate Service Principal to Azure Function App
date: 2017-06-19T22:48:36+00:00
author: nick
layout: post
guid: https://blogs.technet.microsoft.com/neales/?p=225
permalink: /2017/06/19/oauth-using-powershell-and-certificate-service-principal-to-azure-function-app/
opengraph_tags:
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="OAuth using PowerShell and certificate Service Principal to Azure Function App" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2017/06/19/oauth-using-powershell-and-certificate-service-principal-to-azure-function-app/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi, Recently I needed a way to write PowerShell code to use a certificate backed service principal to use OAuth authentication when calling a web hook. This took longer than it should to figure out (my colleague Arian helped a lot), so I figured I may be able to save someone else some time by..." />
    <meta property="og:image" content="https://msdnshared.blob.core.windows.net/media/2017/06/image_thumb420.png" />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="OAuth using PowerShell and certificate Service Principal to Azure Function App" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2017/06/19/oauth-using-powershell-and-certificate-service-principal-to-azure-function-app/" />
    <meta name="twitter:description" content="Hi, Recently I needed a way to write PowerShell code to use a certificate backed service principal to use OAuth authentication when calling a web hook. This took longer than it should to figure out (my colleague Arian helped a lot), so I figured I may be able to save someone else some time by..." />
    <meta name="twitter:image" content="https://msdnshared.blob.core.windows.net/media/2017/06/image_thumb420.png" />
    
categories:
  - Azure
  - Function App
  - PowerShell
tags:
  - Azure
  - Function App
  - OAuth
  - PowerShell
  - Service Principal
---
Hi,

Recently I needed a way to write PowerShell code to use a certificate backed service principal to use OAuth authentication when calling a web hook. This took longer than it should to figure out (my colleague Arian helped a lot), so I figured I may be able to save someone else some time by sharing this online.

For the application you are sending the authenticated web hook to, modify the Authorization settings under “Platform features”:

&nbsp;

[<img title="image" alt="image" src="/wp-content/uploads/2017/06/image_thumb420.png" class="" width="727" border="0" height="380" />](/wp-content/uploads/2017/06/image443.png)

&nbsp;

Enable App Service Authentication, choose AD Auth, and configure the AD Auth setting

[<img title="clip_image001" alt="clip_image001" src="/wp-content/uploads/2017/06/clip_image001_thumb9.png" class="" width="706" border="0" height="489" />](/wp-content/uploads/2017/06/clip_image00110.png)

&nbsp;

Set the following values (sources provided later):

&nbsp;

[<img title="clip_image001[6]" alt="clip_image001[6]" src="/wp-content/uploads/2017/06/clip_image0016_thumb.png" class="" width="699" border="0" height="629" />](/wp-content/uploads/2017/06/clip_image00161.png)

Value 3 is the tenant ID:

[<img title="clip_image002" alt="clip_image002" src="/wp-content/uploads/2017/06/clip_image002_thumb2.png" class="" width="662" border="0" height="96" />](/wp-content/uploads/2017/06/clip_image0022.png)

Values 2 & 4 come from the App Registrations in Azure AD for the Service Principal (these can also be queried via PowerShell if needed (Get-AzureADServicePrincipal)

[<img title="clip_image003" alt="clip_image003" src="/wp-content/uploads/2017/06/clip_image003_thumb1.png" class="" width="768" border="0" height="434" />](/wp-content/uploads/2017/06/clip_image0031.png)

&nbsp;

This is some sample code used to call the webhook & pass some parameters to it, and show the output:

<pre>function Get-AuthHeaderUsingCert {
    param(
        $TenantID,
        $CertificateThumbprint,
        $ApplicationIdURL,
        $ApplicationId
    )
    $AuthUri = "https://login.windows.net/$TenantID/oauth2/authorize"
    $clientCertificate = Get-Item -Path Cert:\CurrentUser\My\$CertificateThumbprint
    $authenticationContext = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext -ArgumentList $AuthUri
    $certificateCredential = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.ClientAssertionCertificate -ArgumentList ($ApplicationId, $clientCertificate)
    $authToken = $authenticationContext.AcquireTokenAsync($ApplicationIdURL, $certificateCredential)
    $authHeader = @{
        'Content-Type'='application/json'
        'Authorization'=$authToken.result.CreateAuthorizationHeader()
    }
    $authHeader
}

add-type -path C:\Temp\Microsoft.IdentityModel.Clients.ActiveDirectory.dll
#I'm using Version 2.28.31117.1411 of this DLL - Apparently newer ones don't work for this.

$AuthHeader = Get-AuthHeaderUsingCert -TenantID $tenantID -CertificateThumbprint $CertificateThumbprint -ApplicationId $ApplicationId -ApplicationIdURL $ApplicationIdURL 
if([string]::IsNullOrWhiteSpace($authheader)){throw "no auth"}
$JSONArguments = $(@{'ArgName'='ArgValue'} | convertto-json -Depth 5)
$Result = Invoke-Webrequest -Uri $WebhookURL -Headers $AuthHeader -Body $JSONArguments -Method Post
$result

</pre>