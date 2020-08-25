---
layout: index
date:   2020-08-25 12:00:00 +1000
page.comments: true
---

# Display Certificate info of remote HTTPS connection

I recently had a need to check the certificate being returned by a remote SSL Connection - this is mostly to check for any impact of a proxy server replacing the SSL cert.

## Ubuntu

```bash
#install nmap tool
apt update && apt-get install -y nmap

#Run command to show certificate info from remote server:
nmap -p 443 --script ssl-cert www.bing.com

#Alternate command if using proxy:
nmap -p 443 --proxy <ProxyAddress>:<ProxyPort> --script ssl-cert www.bing.com

```

## Windows (PowerShell)

This is a script I use since I couldn't find any other way to do this - it's a mishmash of a few different sources I found:


```powershell
param(
    [string]$fqdn='www.bing.com',
    [int]$port=443
)

function check_ssl{
    param(
        [string]$fqdn='www.bing.com',
        [int]$port=443
    )
    #Allow connection to sites with an invalid certificate:
    [Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

    $timeoutMilliseconds = 5000

    $url="https://$fqdn"

    Write-Host `n Checking $url -f Green
     $req = [Net.HttpWebRequest]::Create($url)
     $req.Timeout = $timeoutMilliseconds
     try {$req.GetResponse() | Out-Null} catch {}


     if ($req.ServicePoint.Certificate -ne $null)
    {
        $certinfo = New-Object security.cryptography.x509certificates.x509certificate2($req.ServicePoint.Certificate)
        $certinfo | fl
        $certinfo.Extensions | where {$_.Oid.FriendlyName -like 'subject alt*'} | `
        foreach { $_.Oid.FriendlyName; $_.Format($true) }
    }
}

if(Test-NetConnection -port $port  $fqdn -InformationLevel Quiet){
    check_ssl -fqdn $fqdn -port $port   
}else{
    throw "unable to connect to FQDN '$fqdn' on port $port"
}
```

[Back](./index.md)
