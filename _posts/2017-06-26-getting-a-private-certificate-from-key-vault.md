---
id: 236
title: Getting a private certificate from Key Vault
date: 2017-06-26T22:22:26+00:00
author: nick
layout: post
guid: https://blogs.technet.microsoft.com/neales/?p=236
permalink: /2017/06/26/getting-a-private-certificate-from-key-vault/
opengraph_tags:
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Getting a private certificate from Key Vault" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/?p=236" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Getting a certificate from key vault using PowerShell – while it isn’t obvious also isn’t hard. I’m putting this sample code here for me to use as a reference – but feel free to use &amp; adjust it as you want. A few key points first about certificates in Key Vault. BYO certificates when loaded..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Getting a private certificate from Key Vault" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/?p=236" />
    <meta name="twitter:description" content="Getting a certificate from key vault using PowerShell – while it isn’t obvious also isn’t hard. I’m putting this sample code here for me to use as a reference – but feel free to use &amp; adjust it as you want. A few key points first about certificates in Key Vault. BYO certificates when loaded..." />
    
categories:
  - Certificate
  - Key Vault
  - PowerShell
tags:
  - Certificate
  - Key Vault
  - PowerShell
---
Getting a certificate from key vault using PowerShell – while it isn’t obvious also isn’t hard. I’m putting this sample code here for me to use as a reference – but feel free to use & adjust it as you want.

A few key points first about certificates in Key Vault.

  * BYO certificates when loaded into key vault are added using the \*AzureKeyVaultCertificate\* powershell cmdlets.
  * Key Vault can generate self-signed certificates using the New-AzureKeyVaultCertificatePolicy cmdlet with ‘-IssuerName Self’ and the Add-AzureKeyVaultCertificate cmdlet
  * Private Certificates can then be accessed using the Get-AzureKeyVaultSecret cmdlet
  * Public Certificates  can then be accessed using the Get-AzureKeyVaultKey cmdlet.
  * Access to run each cmdlet is governed through a range of access policies. E.g. ‘Get’ rights on ‘secret’ objects lets you get a secret (e.g. by running Get-AzureKeyVaultSecret with ’-name’), and ‘List’ rights on ‘key’ objects lets you list the keys (e.g. by running Get-AzureKeyVaultKey without ’-name’).
  * the below script assumes that you have authenticated to Key Vault and have permissions for the get operation.

anyway.. some code to get private certificates and make them available for a few difference purposes (the main point of this post):

&nbsp;

<pre><span style="font-family: Consolas;font-size: small">#get Secret object (Containing private key) from Key Vault</span>
<span style="font-family: Consolas;font-size: small">$AzureKeyVaultSecret=Get-AzureKeyVaultSecret -VaultName $VaultName -Name $CertificateName -ErrorAction SilentlyContinue</span>

<span style="font-family: Consolas;font-size: small">#Convert private cert to bytes
$PrivateCertKVBytes = [System.Convert]::FromBase64String($AzureKeyVaultSecret.SecretValueText)</span>

#Convert Bytes to Certificate (flagged as exportable & retaining private key)
#possible flags: <a href="https://msdn.microsoft.com/en-us/library/system.security.cryptography.x509certificates.x509keystorageflags(v=vs.110).aspx"><span style="font-family: Consolas;font-size: small">https://msdn.microsoft.com/en-us/library/system.security.cryptography.x509certificates.x509keystorageflags(v=vs.110).aspx
</span></a><span style="font-family: Consolas;font-size: small">$certObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -argumentlist $PrivateCertKVBytes,$null, "Exportable, PersistKeySet"
</span>

<span style="font-family: Consolas;font-size: small">#Optional: import certificate to current user Certificate store
$Certificatestore = New-Object System.Security.Cryptography.X509Certificates.X509Store -argumentlist "My","Currentuser"
$Certificatestore.open("readWrite")
$Certificatestore.Add($certObject)
$Certificatestore.Close()</span>

<span style="font-family: Consolas;font-size: small">#if private certificate needs to be exported, then it needs a password - create Temporary Random Password for certificate
$PasswordLength=20
$ascii = 33..126 | %{[char][byte]$_}
$CertificatePfxPassword = $(0..$passwordLength | %{$ascii | get-random}) -join ""</span>

<span style="font-family: Consolas;font-size: small">#Encrypt private Certificate using password (required if exporting to file or memory for use in ARM template)
$protectedCertificateBytes = $certObject.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12,
$CertificatePfxPassword)
Write-output "Private Certificate Password: '$CertificatePfxPassword'"</span>

<span style="font-family: Consolas;font-size: small">#Optional: Export encrypted certificate to Base 64 String in memory (for use in ARM templates / other):
$InternetPfxCertdata = [System.Convert]::ToBase64String($protectedCertificateBytes)</span>

<span style="font-family: Consolas;font-size: small">#Optional: Export encrypted certificate to file on desktop:
$pfxPath = '{0}\{1}.pfx' -f [Environment]::GetFolderPath("Desktop") ,$CertificateName
[System.IO.File]::WriteAllBytes($pfxPath, $protectedCertificateBytes)</span></pre>

&nbsp;

While the above example is for getting a private certificate, getting a public certificate is similar & simpler. (use Get-AzureKeyVaultKey instead / a slight change to the flags if importing it locally / no need to encrypt if exporting to a .CER file).

As always – please let me know if you have any questions or comments – that’s how I learn.