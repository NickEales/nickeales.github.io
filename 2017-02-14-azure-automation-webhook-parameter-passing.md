---
layout: default
title:  "Azure Automation Webhook parameter passing"
date:   2017-02-14 12:00:00 +1000
categories: Azure Automation PowerShell
excerpt_separator: <!--more-->
---
Recently I was exploring the use of webhooks & needed to troubleshoot the parameters being passed to a webhook.
<!--more-->

This is the Azure Automation PowerShell runbook that I used to display what was being passed to the webhook:

```powershell
param (
    [object]$WebhookData
)

# If runbook was called from Webhook, WebhookData will not be null.
if ($WebhookData -ne $null) {
        $webhookbody = convertfrom-json $webhookdata.RequestBody
        $webhookbody.context.timestamp | write-output
        $webhookbody.context.event.OperationName | write-output
        $webhookbody.context.resourceId | write-output
        $webhookbody.context | write-output
        $webhookbody | write-output
}
```

As usual for any of my blog posts – if you have any feedback about any of the above, please provide it – that’s how I learn.
