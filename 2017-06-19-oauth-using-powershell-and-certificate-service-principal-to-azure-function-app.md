---
layout: default
date:   2017-06-19 21:42:46 +1000
categories: Azure Certificates PowerShell ServicePrincipal Oauth
excerpt_separator: <!--more-->
---
# OAuth using PowerShell and certificate Service Principal to Azure Function App

I needed a way to write PowerShell code to use a certificate backed service principal to use OAuth authentication when calling a web hook.
<!--more-->

This took longer than it should to figure out (my colleague Arian helped a lot), so I figured I may be able to save someone else some time by sharing this online.

For the application you are sending the authenticated web hook to, modify the Authorization settings under "Platform features":

![useful image]({{ site.url }}/assets/2017-06-19-OAuth-image1.png)

Enable App Service Authentication, choose AD Auth, and configure the AD Auth setting

![useful image]({{ site.url }}/assets/2017-06-19-OAuth-image2.png)

Set the following values (sources provided later):

![useful image]({{ site.url }}/assets/2017-06-19-OAuth-image3.png)

Value 3 is the tenant ID:

![useful image]({{ site.url }}/assets/2017-06-19-OAuth-image4.png)

Values 2 & 4 come from the App Registrations in Azure AD for the Service Principal (these can also be queried via PowerShell if needed (Get-AzureADServicePrincipal)

![useful image]({{ site.url }}/assets/2017-06-19-OAuth-image5.png)

This is some sample code used to call the webhook & pass some parameters to it, and show the output:

    function Get-AuthHeaderUsingCert {
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

