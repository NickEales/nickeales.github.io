---
id: 115
title: Use a Custom Script Extension to Sysprep an Azure VM
date: 2017-03-13T10:33:33+00:00
author: nick
layout: post
guid: https://blogs.technet.microsoft.com/neales/?p=115
permalink: /2017/03/13/use-a-custom-script-extension-to-sysprep-an-azure-vm/
opengraph_tags:
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Use a Custom Script Extension to Sysprep an Azure VM" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2017/03/13/use-a-custom-script-extension-to-sysprep-an-azure-vm/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi All, I’ve been in a situation where I want to run sysprep on a Azure VM to create an image, hopefully without needing to login / connect directly to the VM. I thought that this was an opportunity to learn about custom script extensions. (for use in other situations as well) &nbsp; in summary,..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Use a Custom Script Extension to Sysprep an Azure VM" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2017/03/13/use-a-custom-script-extension-to-sysprep-an-azure-vm/" />
    <meta name="twitter:description" content="Hi All, I’ve been in a situation where I want to run sysprep on a Azure VM to create an image, hopefully without needing to login / connect directly to the VM. I thought that this was an opportunity to learn about custom script extensions. (for use in other situations as well) &nbsp; in summary,..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Use a Custom Script Extension to Sysprep an Azure VM" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2017/03/13/use-a-custom-script-extension-to-sysprep-an-azure-vm/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi All, I’ve been in a situation where I want to run sysprep on a Azure VM to create an image, hopefully without needing to login / connect directly to the VM. I thought that this was an opportunity to learn about custom script extensions. (for use in other situations as well) &nbsp; in summary,..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Use a Custom Script Extension to Sysprep an Azure VM" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2017/03/13/use-a-custom-script-extension-to-sysprep-an-azure-vm/" />
    <meta name="twitter:description" content="Hi All, I’ve been in a situation where I want to run sysprep on a Azure VM to create an image, hopefully without needing to login / connect directly to the VM. I thought that this was an opportunity to learn about custom script extensions. (for use in other situations as well) &nbsp; in summary,..." />
    
categories:
  - Azure
  - PowerShell
tags:
  - Azure
  - PowerShell
---
<div class="post">
  <div class="body">
    <div class="postBody" id="e55ae3a2-7a29-43fd-a073-2e472750f254" style="margin: 4px 0px 0px;border-width: 0px;padding: 0px">
      <p>
        Hi All,
      </p>
      
      <p>
        I’ve been in a situation where I want to run sysprep on a Azure VM to create an image, hopefully without needing to login / connect directly to the VM. I thought that this was an opportunity to learn about custom script extensions. (for use in other situations as well)
      </p>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        in summary, I created a powershell script file, and saved it to a new file &#8216;sysprep.ps1&#8217;:
      </p>
      
      <pre>param([switch]$runSysprep=$false)
write-output "Sysprep Script Run, parameter 'runSysprep': $runSysprep"

if($runSysprep){
  write-output "starting Sysprep"
  Start-Process -FilePath C:\Windows\System32\Sysprep\Sysprep.exe -ArgumentList '/generalize /oobe /shutdown /quiet'
  write-output "started Sysprep"
}else{
  write-output "skipping Sysprep"
}
</pre>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        I then uploaded this to a storage account, set the security on the container to ‘blob’ (there&#8217;s nothing sensitive in that script), then ran the following:
      </p>
      
      <pre>$VMName =  'vmName'
$VMRG = 'vmResourceGroup'
$VMLocation = 'AustraliaEast'
$ExtensionName = 'runsysprep'
$Scripturi = 'https://&lt;storageAccountName&gt;.blob.core.windows.net/templates/scripts/sysprep.ps1'
Set-AzureRmVMCustomScriptExtension -FileUri $ScriptURI -ResourceGroupName  $VMRG -VMName $VMName -Name $ExtensionName -Location $VMLocation -run './sysprep.ps1' -Argument '-runSysprep'</pre>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        This gave the output:
      </p>
      
      <pre>RequestId IsSuccessStatusCode StatusCode ReasonPhrase
--------- ------------------- ---------- ------------
                         True         OK OK</pre>
      
      <p>
        To see the output messages from the script that was run:
      </p>
      
      <pre>$status = Get-AzureRmVMDiagnosticsExtension -ResourceGroupName $VMRG -VMName $VMName -Name $ExtensionName -Status
$status.SubStatuses.message</pre>
      
      <p>
        This displayed the output that was expected:
      </p>
      
      <pre>Sysprep Script Run, parameter 'runSysprep': True\nstarting Sysprep\nstarted Sysprep</pre>
      
      <p>
        &nbsp;
      </p>
      
      <p>
        A short time later, the VM is shutdown (but is still allocated & incurring charges), so i then shutdown the VM:
      </p>
    </div>
  </div>
</div>

<pre>Stop-AzureRmVM -Name $VMName -ResourceGroupName $VMRG  -force</pre>

<div class="post">
  <div class="body">
    <div class="postBody" id="e55ae3a2-7a29-43fd-a073-2e472750f254" style="margin: 4px 0px 0px;border-width: 0px;padding: 0px">
      <p>
        &nbsp;
      </p>
      
      <p>
        As with everything I post about, please give comments / questions on my approach /methods
      </p>
      
      <p>
        Nick
      </p>
    </div>
  </div>
</div>