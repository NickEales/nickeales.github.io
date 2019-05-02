---
id: 75
title: ARM template parameter for API version selection (latest vs known)
date: 2017-02-07T02:00:31+00:00
author: nick
layout: post
guid: https://blogs.technet.microsoft.com/neales/?p=75
permalink: /2017/02/07/arm-template-parameter-for-api-version-selection-latest-vs-known/
opengraph_tags:
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="ARM template parameter for API version selection (latest vs known)" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2017/02/07/arm-template-parameter-for-api-version-selection-latest-vs-known/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi All, Each resource type within a resource provider support a range of API versions. An API version details the available properties of the resource type at a specific point in time. This allows resources to be updated independently of other resources. This also allows you to write templates today that will still function correctly..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="ARM template parameter for API version selection (latest vs known)" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2017/02/07/arm-template-parameter-for-api-version-selection-latest-vs-known/" />
    <meta name="twitter:description" content="Hi All, Each resource type within a resource provider support a range of API versions. An API version details the available properties of the resource type at a specific point in time. This allows resources to be updated independently of other resources. This also allows you to write templates today that will still function correctly..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="ARM template parameter for API version selection (latest vs known)" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2017/02/07/arm-template-parameter-for-api-version-selection-latest-vs-known/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi All, Each resource type within a resource provider support a range of API versions. An API version details the available properties of the resource type at a specific point in time. This allows resources to be updated independently of other resources. This also allows you to write templates today that will still function correctly..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="ARM template parameter for API version selection (latest vs known)" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2017/02/07/arm-template-parameter-for-api-version-selection-latest-vs-known/" />
    <meta name="twitter:description" content="Hi All, Each resource type within a resource provider support a range of API versions. An API version details the available properties of the resource type at a specific point in time. This allows resources to be updated independently of other resources. This also allows you to write templates today that will still function correctly..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="ARM template parameter for API version selection (latest vs known)" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2017/02/07/arm-template-parameter-for-api-version-selection-latest-vs-known/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi All, Each resource type within a resource provider support a range of API versions. An API version details the available properties of the resource type at a specific point in time. This allows resources to be updated independently of other resources. This also allows you to write templates today that will still function correctly..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="ARM template parameter for API version selection (latest vs known)" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2017/02/07/arm-template-parameter-for-api-version-selection-latest-vs-known/" />
    <meta name="twitter:description" content="Hi All, Each resource type within a resource provider support a range of API versions. An API version details the available properties of the resource type at a specific point in time. This allows resources to be updated independently of other resources. This also allows you to write templates today that will still function correctly..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="ARM template parameter for API version selection (latest vs known)" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2017/02/07/arm-template-parameter-for-api-version-selection-latest-vs-known/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi All, Each resource type within a resource provider support a range of API versions. An API version details the available properties of the resource type at a specific point in time. This allows resources to be updated independently of other resources. This also allows you to write templates today that will still function correctly..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="ARM template parameter for API version selection (latest vs known)" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2017/02/07/arm-template-parameter-for-api-version-selection-latest-vs-known/" />
    <meta name="twitter:description" content="Hi All, Each resource type within a resource provider support a range of API versions. An API version details the available properties of the resource type at a specific point in time. This allows resources to be updated independently of other resources. This also allows you to write templates today that will still function correctly..." />
    
categories:
  - ARM template
  - Azure
tags:
  - ARM
  - Azure
---
Hi All,

<div>
  Each resource type within a resource provider support a range of API versions. An API version details the available properties of the resource type at a specific point in time. This allows resources to be updated independently of other resources. This also allows you to write templates today that will still function correctly as new versions of the resource providers are released. It is important to strongly version your resources as different API versions for the same resource type can have different properties. Strong versioning means that the API version is always statically specified instead of retrieving the latest API version dynamically at runtime.
</div>

<div>
</div>

<div>
  One of the projects I’m working on, includes building ARM templates that are going to be used (hopefully without alteration) for a long time. While we are building the ARM template, we wanted to use the latest API versions, and then have the ability to easily switch to a static set of known API version when we are ready to publish. This will avoid any breaking changes unexpectedly causing deployments to fail.
</div>

<div>
</div>

<div>
  Enabling it to be simple to switch between the latest and known versions of the ARM API&#8217;s may sound tricky to do in a single template, but it is simpler than it appears.
</div>

The API versions for each resource type can be displayed by this command:

get-AzureRmResourceProvider | %{$Provider = $\_.ProviderNameSpace;$\_ | select -expand ResourceTypes | select -Property @{N=&#8221;Provider&#8221;;E={$Provider}},ResourceTypeName,APIVersions}

An adaptation of the [Quickstart Windows VM template](https://github.com/Azure/azure-quickstart-templates/tree/master/101-vm-simple-windows) with these modifications is displayed below. I have highlighted the changed lines.

&nbsp;

* * *

<pre>{
  "$schema": "<a href="https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#&quot;">https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"</a>,
  "contentVersion": "1.0.0.0",
  "parameters": {
    "adminUsername": {
      "type": "string",
      "metadata": {
        "description": "Username for the Virtual Machine."
      }
    },
    "adminPassword": {
      "type": "securestring",
      "metadata": {
        "description": "Password for the Virtual Machine."
      }
    },
    "dnsLabelPrefix": {
      "type": "string",
      "metadata": {
        "description": "Unique DNS Name for the Public IP used to access the Virtual Machine."
      }
    },
    "windowsOSVersion": {
      "type": "string",
      "defaultValue": "2016-Datacenter",
      "allowedValues": [
        "2008-R2-SP1",
        "2012-Datacenter",
        "2012-R2-Datacenter",
        "2016-Nano-Server",
        "2016-Datacenter-with-Containers",
        "2016-Datacenter"
      ],
      "metadata": {
        "description": "The Windows version for the VM. This will pick a fully patched image of this given Windows version."
      }
    }<span style="background-color: #ffff00">,
    "apiVersionChoice": {
      "type": "string",
      "defaultValue": "known",
      "allowedValues": [
        "latest",
        "known"
      ]
    }</span>
  },
  "variables": {
    "storageAccountName": "[concat(uniquestring(resourceGroup().id), 'elestest')]",
    "nicName": "myVMNic",
    "addressPrefix": "10.0.0.0/16",
    "subnetName": "Subnet",
    "subnetPrefix": "10.0.0.0/24",
    "publicIPAddressName": "myPublicIP",
    "vmName": "SimpleWinVM",
    "virtualNetworkName": "MyVNET",
    "subnetRef": "[resourceId('Microsoft.Network/virtualNetworks/subnets', variables('virtualNetworkName'), variables('subnetName'))]"<span style="background-color: #ffff00">,
    "APIVersionsRef": {
      "latest": {
        "storageAccounts": "[providers('Microsoft.Storage','storageAccounts').apiVersions[0]]",
        "publicIPAddresses": "[providers('Microsoft.Network','publicIPAddresses').apiVersions[0]]",
        "virtualNetworks": "[providers('Microsoft.Network','virtualNetworks').apiVersions[0]]",
        "networkInterfaces": "[providers('Microsoft.Network','networkInterfaces').apiVersions[0]]",
        "virtualMachines": "[providers('Microsoft.Compute','virtualMachines').apiVersions[0]]"
      },
      "known": {
        "storageAccounts": "2015-06-01",
        "publicIPAddresses": "2016-03-30",
        "virtualNetworks": "2016-03-30",
        "networkInterfaces": "2016-03-30",
        "virtualMachines": "2015-06-15"
      }
    },
    "APIVersions": "[variables('APIVersionsRef')[parameters('apiVersionChoice')]]"</span>


  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts",
      "name": "[variables('storageAccountName')]",
      "apiVersion": <span style="background-color: #ffff00">"[variables('APIVersions').storageAccounts]"</span>,
      "location": "[resourceGroup().location]",
      "sku": {
        "name": "Standard_LRS"
      },
      "kind": "Storage",
      "properties": {}
    },
    {
      "apiVersion": <span style="background-color: #ffff00">"[variables('APIVersions').publicIPAddresses]"</span>,
      "type": "Microsoft.Network/publicIPAddresses",
      "name": "[variables('publicIPAddressName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "publicIPAllocationMethod": "Dynamic",
        "dnsSettings": {
          "domainNameLabel": "[parameters('dnsLabelPrefix')]"
        }
      }
    },
    {
      "apiVersion": <span style="background-color: #ffff00">"[variables('APIVersions').virtualNetworks]"</span>,
      "type": "Microsoft.Network/virtualNetworks",
      "name": "[variables('virtualNetworkName')]",
      "location": "[resourceGroup().location]",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "[variables('addressPrefix')]"
          ]
        },
        "subnets": [
          {
            "name": "[variables('subnetName')]",
            "properties": {
              "addressPrefix": "[variables('subnetPrefix')]"
            }
          }
        ]
      }
    },
    {
      "apiVersion": <span style="background-color: #ffff00">"[variables('APIVersions').networkInterfaces]"</span>,
      "type": "Microsoft.Network/networkInterfaces",
      "name": "[variables('nicName')]",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[resourceId('Microsoft.Network/publicIPAddresses/', variables('publicIPAddressName'))]",
        "[resourceId('Microsoft.Network/virtualNetworks/', variables('virtualNetworkName'))]"
      ],
      "properties": {
        "ipConfigurations": [
          {
            "name": "ipconfig1",
            "properties": {
              "privateIPAllocationMethod": "Dynamic",
              "publicIPAddress": {
                "id": "[resourceId('Microsoft.Network/publicIPAddresses',variables('publicIPAddressName'))]"
              },
              "subnet": {
                "id": "[variables('subnetRef')]"
              }
            }
          }
        ]
      }
    },
    {
      "apiVersion": <span style="background-color: #ffff00">"[variables('APIVersions').virtualMachines]"</span>,
      "type": "Microsoft.Compute/virtualMachines",
      "name": "[variables('vmName')]",
      "location": "[resourceGroup().location]",
      "dependsOn": [
        "[resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))]",
        "[resourceId('Microsoft.Network/networkInterfaces/', variables('nicName'))]"
      ],
      "properties": {
        "hardwareProfile": {
          "vmSize": "Standard_A2"
        },
        "osProfile": {
          "computerName": "[variables('vmName')]",
          "adminUsername": "[parameters('adminUsername')]",
          "adminPassword": "[parameters('adminPassword')]"
        },
        "storageProfile": {
          "imageReference": {
            "publisher": "MicrosoftWindowsServer",
            "offer": "WindowsServer",
            "sku": "[parameters('windowsOSVersion')]",
            "version": "latest"
          },
          "osDisk": {
            "name": "osdisk",
            "vhd": {
              "uri": "[concat(reference(resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))).primaryEndpoints.blob, 'vhds/osdisk.vhd')]"
            },
            "caching": "ReadWrite",
            "createOption": "FromImage"
          },
          "dataDisks": [
            {
              "name": "datadisk1",
              "diskSizeGB": "100",
              "lun": 0,
              "vhd": {
                "uri": "[concat(reference(resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))).primaryEndpoints.blob, 'vhds/datadisk1.vhd')]"
              },
              "createOption": "Empty"
            }
          ]
        },
        "networkProfile": {
          "networkInterfaces": [
            {
              "id": "[resourceId('Microsoft.Network/networkInterfaces',variables('nicName'))]"
            }
          ]
        },
        "diagnosticsProfile": {
          "bootDiagnostics": {
            "enabled": "true",
            "storageUri": "[reference(resourceId('Microsoft.Storage/storageAccounts/', variables('storageAccountName'))).primaryEndpoints.blob]"
          }
        }
      }
    }
  ],
  "outputs": {
    "hostname": {
      "type": "string",
      "value": "[reference(variables('publicIPAddressName')).dnsSettings.fqdn]"
    }
  }
}</pre>

* * *

As usual for any of my blog posts – if you have any feedback about any of the above, please provide it – that’s how I learn.

Thanks for input on this post &#8211; Marc van Eijk.