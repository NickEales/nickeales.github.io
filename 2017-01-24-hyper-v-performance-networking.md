---
layout: default
title:  "Hyper-V Performance – Network"
date:   2017-01-24 12:00:00 +1000
categories: Hyper-V Performance Network
excerpt_separator: <!--more-->
---
Network monitoring in a Hyper-V environment depends very heavily on the configuration in use, the available hardware (speed of NIC) and the configuration in use.
<!--more-->
This is a continuation of a series on Hyper-V performance monitoring. The previous posts covered CPU, Storage and Memory performance, This post is on network performance.

## Physical network adapter throughput

* Counter: **Network Interface\Bytes Total/sec**
* Why: This show how busy each physical NIC is.
* Threshold: 90% of Network hardware speed (both NIC and connected switch)
* What to do if threshold is met or exceeded:
  * Ensure that you are applying weights to the network traffic to prioritize traffic types in this order (there are several methods to apply these weights - depending on the network config, and this all changes for Win2016):
    * Host Management,
    * CSV storage (Win2012 R2 and earlier)
    * VM storage
    * Live Migration (if using dynamic optimization or some other automatic load balancing method - otherwise put this last)
    * VM traffic
  * If the prioritization has already occurred, and any suboptimal performance is occurring, then either:
    * increase capacity (more / faster NICs & switches)
    * Reduce load by shifting workloads to other hosts

## Virtual Machine Network throughput

* Counter: **Hyper-V Virtual Network Adapter\Bytes/sec**
* Why: This shows the network throughput for each VM Network adapter. This can be used for capacity planning and for load tracking purposes.
* Threshold: This depends on the type of environment (most environments won't use a threshold, but will keep it for capacity planning)

I'm sure there are more counters that are relevant - if you have suggestions, please let me know (if they are storage related, please check that post first).

As usual for any of my blog posts – if you have any feedback about any of the above, please provide it – that’s how I learn

[Back](./index.md)
