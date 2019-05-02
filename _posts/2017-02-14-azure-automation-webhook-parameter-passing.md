---
id: 85
title: Azure Automation Webhook parameter passing
date: 2017-02-14T02:00:00+00:00
author: nick
layout: post
guid: https://blogs.technet.microsoft.com/neales/?p=85
permalink: /2017/02/14/azure-automation-webhook-parameter-passing/
opengraph_tags:
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Azure Automation Webhook parameter passing" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/?p=85" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi All, Recently I was exploring the use of webhooks &amp; needed to troubleshoot the parameters being passed to a webhook. With the theme of my blog &#8211; hoping to save someone some time, this is a quick post to save someone creating this from scratch. This is the Azure Automation PowerShell runbook that I used..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Azure Automation Webhook parameter passing" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/?p=85" />
    <meta name="twitter:description" content="Hi All, Recently I was exploring the use of webhooks &amp; needed to troubleshoot the parameters being passed to a webhook. With the theme of my blog &#8211; hoping to save someone some time, this is a quick post to save someone creating this from scratch. This is the Azure Automation PowerShell runbook that I used..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Azure Automation Webhook parameter passing" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/?p=85" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi All, Recently I was exploring the use of webhooks &amp; needed to troubleshoot the parameters being passed to a webhook. With the theme of my blog &#8211; hoping to save someone some time, this is a quick post to save someone creating this from scratch. This is the Azure Automation PowerShell runbook that I used..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Azure Automation Webhook parameter passing" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/?p=85" />
    <meta name="twitter:description" content="Hi All, Recently I was exploring the use of webhooks &amp; needed to troubleshoot the parameters being passed to a webhook. With the theme of my blog &#8211; hoping to save someone some time, this is a quick post to save someone creating this from scratch. This is the Azure Automation PowerShell runbook that I used..." />
    
categories:
  - Azure
tags:
  - Automation
  - Azure
  - Azure Automation
---
Hi All,

Recently I was exploring the use of webhooks & needed to troubleshoot the parameters being passed to a webhook.

With the theme of my blog &#8211; hoping to save someone some time, this is a quick post to save someone creating this from scratch.

This is the Azure Automation PowerShell runbook that I used to display what was being passed to the webhook:

<pre>param (
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

</pre>

As usual for any of my blog posts – if you have any feedback about any of the above, please provide it – that’s how I learn.