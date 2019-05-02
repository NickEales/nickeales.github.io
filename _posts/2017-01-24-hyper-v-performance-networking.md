---
id: 55
title: 'Hyper-V Performance &#8211; Networking'
date: 2017-01-24T14:15:49+00:00
author: nick
layout: post
guid: https://blogs.technet.microsoft.com/neales/?p=55
permalink: /2017/01/24/hyper-v-performance-networking/
opengraph_tags:
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Hyper-V Performance &#8211; Networking" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/?p=55" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="This is a continuation of a series on Hyper-V performance monitoring. The previous posts covered CPU, Storage and Memory performance, This post is on network performance. Network monitoring in a Hyper-V environment depends very heavily on the configuration in use, the available hardware (speed of NIC) and the configuration in use. &nbsp; Physical network adapter..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Hyper-V Performance &#8211; Networking" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/?p=55" />
    <meta name="twitter:description" content="This is a continuation of a series on Hyper-V performance monitoring. The previous posts covered CPU, Storage and Memory performance, This post is on network performance. Network monitoring in a Hyper-V environment depends very heavily on the configuration in use, the available hardware (speed of NIC) and the configuration in use. &nbsp; Physical network adapter..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Hyper-V Performance &#8211; Networking" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/?p=55" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="This is a continuation of a series on Hyper-V performance monitoring. The previous posts covered CPU, Storage and Memory performance, This post is on network performance. Network monitoring in a Hyper-V environment depends very heavily on the configuration in use, the available hardware (speed of NIC) and the configuration in use. &nbsp; Physical network adapter..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Hyper-V Performance &#8211; Networking" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/?p=55" />
    <meta name="twitter:description" content="This is a continuation of a series on Hyper-V performance monitoring. The previous posts covered CPU, Storage and Memory performance, This post is on network performance. Network monitoring in a Hyper-V environment depends very heavily on the configuration in use, the available hardware (speed of NIC) and the configuration in use. &nbsp; Physical network adapter..." />
    
categories:
  - Hyper-V
  - Performance
tags:
  - Hyper-V
---
This is a continuation of a series on Hyper-V performance monitoring. The previous posts covered CPU, Storage and Memory performance, This post is on network performance.

Network monitoring in a Hyper-V environment depends very heavily on the configuration in use, the available hardware (speed of NIC) and the configuration in use.

&nbsp;

# Physical network adapter throughput

Counter: **Network Interface\Bytes Total/sec**

Why: This show how busy each physical NIC is.

Threshold: 90% of Network hardware speed (both NIC and connected switch)

What to do if threshold is met or exceeded:

  * Ensure that you are applying weights to the network traffic to prioritize traffic types in this order (there are several methods to apply these weights &#8211; depending on the network config, and this all changes for Win2016): 
      1. Host Management,
      2. CSV storage (Win2012 R2 and earlier)
      3. VM storage
      4. Live Migration (if using dynamic optimization or some other automatic load balancing method &#8211; otherwise put this last)
      5. VM traffic
  * If the prioritization has already occurred, and any suboptimal performance is occurring, then either: 
      * increase capacity (more / faster NICs & switches)
      * Reduce load by shifting workloads to other hosts

&nbsp;

# Virtual Machine Network throughput

Counter: **Hyper-V Virtual Network Adapter\Bytes/sec**

Why: This shows the network throughput for each VM Network adapter. This can be used for capacity planning and for load tracking purposes.

Threshold: This depends on the type of environment (most environments won&#8217;t use a threshold, but will keep it for capacity planning)

&nbsp;

I&#8217;m sure there are more counters that are relevant &#8211; if you have suggestions, please let me know (if they are storage related, please check that post first).

&nbsp;

As usual for any of my blog posts – if you have any feedback about any of the above, please provide it – that’s how I learn