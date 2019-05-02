---
id: 35
title: 'Hyper-V Performance &#8211; CPU'
date: 2016-10-24T20:58:58+00:00
author: nick
layout: post
guid: https://blogs.technet.microsoft.com/neales/?p=35
permalink: /2016/10/24/hyper-v-performance-cpu/
opengraph_tags:
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Hyper-V Performance &#8211; CPU" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2016/10/24/hyper-v-performance-cpu/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="Hi &#8211; I&#8217;m Nick Eales from the Microsoft Premier Field Engineering team, based in Sydney Australia. I frequently get asked by both Microsoft people as well as customers how to monitor Hyper-V. This generally really means that people want specific performance counters and thresholds &#8211; and these are not easily found in any form of..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Hyper-V Performance &#8211; CPU" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2016/10/24/hyper-v-performance-cpu/" />
    <meta name="twitter:description" content="Hi &#8211; I&#8217;m Nick Eales from the Microsoft Premier Field Engineering team, based in Sydney Australia. I frequently get asked by both Microsoft people as well as customers how to monitor Hyper-V. This generally really means that people want specific performance counters and thresholds &#8211; and these are not easily found in any form of..." />
    
categories:
  - Hyper-V
  - Performance
tags:
  - Hyper-V
  - Performance
---
Hi &#8211; I&#8217;m Nick Eales from the Microsoft Premier Field Engineering team, based in Sydney Australia.

I frequently get asked by both Microsoft people as well as customers how to monitor Hyper-V. This generally really means that people want specific performance counters and thresholds &#8211; and these are not easily found in any form of consolidated list &#8211; which is what I hope to provide (across a few blog entries). I also aim to provide what each counter means (in real world terms), and what to do / look at to figure out why it exceeds the thresholds.

A word of caution &#8211; I have provided values that are what I initially use when reviewing a customer environment. The thresholds often need to be varied based on hardware and requirements. These starting values are based on experience at large numbers of customer environments worldwide (by my colleagues & I), while reviewing and troubleshooting Hyper-V.

My focus when choosing these counters and values is what will change the &#8220;feel&#8221; and &#8220;responsiveness&#8221; of the virtual machines running on these servers. If these are met, then throughput will usually look after itself.

There are four typical areas that you monitor in any server environment &#8211; CPU, Disk, Memory and Network. Hyper-V is no different &#8211; although the counters used to measure these a Hyper-V environment are often totally different to a standard server.

This post is going to focus on the CPU Performance counters &#8211; since they generate the most confusion. Later posts will address the other areas.

### Physical CPU utilization

  * Counter: Hyper-V Hypervisor Logical Processor(*)\%Total Run Time.
  * Threshold: (any instance) > 50% sustained for > 5 min)
  * What to do if threshold is exceeded: 
      * <div style="margin-right: 0px">
          If _Total meets this, identify sources of CPU load (sounds obvious but.. )
        </div>
    
      * <div style="margin-right: 0px">
          If single / small % of CPUs consistently affected, especially (but not necessarily) CPU 0 look for VMQ / RSS config issues, or other hardware issue.
        </div>
    
      * <div style="margin-right: 0px">
          If a small number of CPUs are impacted, but the busy CPU does vary, then check the two &#8220;% Guest Run Time&#8221; processor counters below.
        </div>

### Management operating system CPU usage.

  * Counter: Hyper-V Hypervisor Root Virtual Processor(_Total)\% Guest Run Time.
  * Threshold (_Total instance) > 5% sustained for > 5 min
  * What: This measures the amount of physical CPU time spent running Hyper-V host OS virtual CPUs.
  * Why: The host OS doesn&#8217;t compete for CPU time in Hyper-V. It always immediately gets any CPU time it needs, which is necessary to provide great performance for virtual machines. This means any unnecessary CPU usage in the host OS can have a significant negative performance impact on all virtual machines &#8211; which is why the guidance is to install as little as possible on the host OS (absolute minimum of agents, services & applications).
  * What to do if threshold is exceeded: 
      * Check for any non-default OS running services / agents / processes in this OS, and review if they are really necessary.
      * Check VMQ/RSS configuration (if 10GB NICs are in use) and for bad drivers &#8211; especially if this the CPU usage is focused on a small percentage of the hosts OS&#8217;s VPs.
      * Standard CPU performance troubleshooting &#8211; as if it was a physical machine.
      * For general administration, use remote management tools instead of locally or via RDP on the host.

&nbsp;

### Virtual Machine Processor Usage

  * Counter: Hyper-V Hypervisor Virtual Processor(*)\% Guest Run Time.
  * Threshold (any instance) > 75%, sustained for > 10min
  * What: This measures the amount of physical CPU time each VM virtual CPU instance uses. Each virtual processor can only run on one physical CPU thread at a time.
  * Why: Unlike the Processor performance object and task manager inside a virtual machine, this accurately shows how much physical CPU time is being consumed by each VP.
  * What to do if threshold is exceeded: 
      * Check VMs have sufficient VP (consider adding one of more processors to the VM)
      * Perform standard high CPU usage troubleshooting inside the VM as you would if it was a physical machine to reduce the CPU usage within the VM.

&nbsp;

### Physical CPU Context Switching

  * What: This measures the rate (number of times per second) each logical CPU changes what virtual processor it is running.
  * Counter: Hyper-V Hypervisor Logical Processor(*)\Context Switches/sec.
  * Threshold: (any instance except for &#8220;_Total&#8221;) > 20000, (sustained for > 5min).
  * Why: We use this as a general health & performance indicator for the host & virtual machines. This counter must be used in context with all other activity based counters (CPU, Disk & Network, latency & throughput).
  * What to do if threshold is exceeded: 
      * Check VM config (particularly remove / disable any active & busy emulated devices)
      * Check that the VM is using the correct version of the integration components.
      * Check host operating system utilization Root VP CPU usage (host OS utilization) &#8211; see the &#8220;Hyper-V Hypervisor Root Virtual Processor&#8221; counter section for the specifics.
      * Check drivers &#8211; particularly network and storage drivers, but other too.
      * Check for significant inconsistency across your hosts &#8211; it can indicate significant configuration or load differences.

&nbsp;

In a Hyper-V environment, please try to avoid using &#8220;Processor\% Processor Time&#8221; &#8211; for Hyper-V this does not measure physical CPU usage. This counter measures the amount of time the CPU is not idle within a specific operating system&#8217;s view &#8211; and the timer that it uses for this calculation is dependent on exclusive use of the CPU &#8211; which is not the case in a Hyper-V environment. For similar reasons, please do not use &#8220;Processor\Processor Queue Length&#8221;.

As usual for any of my blog posts &#8211; if you have any feedback about any of the above, please provide it &#8211; that&#8217;s how I learn.