---
layout: default
date:   2016-11-07 12:00:00 +1000
categories: Hyper-V Performance Storage
excerpt_separator: <!--more-->
---
# Hyper-V Performance – Storage

Storage performance is often the most impactful on the performance and responsiveness of Hyper-V virtual machines.
<!--more-->
This is a continuation of a series on Hyper-V performance monitoring. The previous post covered CPU performance, This post is on storage performance, and the remaining posts will cover memory and network.

## Disk Latency of the virtual machine storage from the host.

* Why: Latency to the Virtual Machine data from Hyper-V is the most common cause of non-optimal virtual machine performance. It significantly helps to know what the normal range is in an specific environment before troubleshooting. This is the first (and for performance – the most important) storage counter to look at.
* Counters:
  * For CSV Disks containing virtual machine data:
    * **Cluster CSV File System(*)\Read Latency**
    * **Cluster CSV File System(*)\Write Latency**
  * For both CSV or SMB Storage:
    * **SMB Client Shares(*)\Avg. sec/Data Request** (only shares containing virtual machine data)
  * When local storage used for VMs (typically non-highly available virtual machines)
    * **Logical Disk(*)\Avg. Disk sec/Transfer** (only instances containing virtual machine data)
* Threshold (for all of the disk latency thresholds): 0.015 (15ms) is a general threshold, but this will vary - Client virtualization may have higher thresholds (25ms), and server virtualization may have lower thresholds (often 8ms or lower).
* What to do if threshold is exceeded:
  * For non-local storage:
  * Check connection to storage - everything from storage adapters (NIC or FC) to the physical disks, inclusive.
    * Check storage unit load & latency issues
    * Check storage adapter driver & settings (including any load balancing or multipath configuration)
    * Check storage unit and storage path load (both MB/Sec and IOPS) vs baseline numbers.
  * For local storage
    * Check local machine CPU (look for any single cores running 100%), and disk idle time

## Disk Idle Time

* Why: This counter provides a clear measurement of what percentage of time the disk remained in idle state, meaning all the requests from the operating system to the disk have been completed and there is zero pending requests. Disk performance (and virtual machine responsiveness) will usually degrade significantly soon after this threshold is reached.
* Counter: **Logical Disk(*)\% Idle Time** (any instance)
* Threshold: < 50% , sustained > 5 min
* What to do if threshold is exceeded:
  * Check storage unit load & latency issues
  * Check storage adapter driver & settings (including any load balancing or multipath configuration
  * Check storage load (MB/Sec and IOPS) vs baseline numbers.
  * Identify busy virtual machine virtual disks (see "Hyper-V Virtual Storage Device\Normalized Throughput" in this post), and consider redistributing the busy virtual machine virtual disks.

## Disk Space

* Why: It is very important to track disks running low on space. When the available space drive containing virtual machine storage falls too low, any operation that involves using more disk space will cause the virtual machine to have an outage and will show a status of "Paused-Critical" (visible in Hyper-V manager). The threshold chosen here should give ample warning before this outage occurs.
* Counter: **Logical Disk(*)\Free Megabytes** (any instance other than "_Total" or "C:")
* Threshold: < 200GB (or whatever threshold is appropriate)
  * the value should depend on disk capacity, expected growth, file system type, backup technology and size of regular fluctuations. Suggested values range from 5% (>10TB disks) to 15 % (<1TB disks).
  * If the underlying storage is thinly provisioned, this threshold should generally be 15%.
  * This counter won't show data for remotely accessed SMB storage.
* What to do if threshold is exceeded:
  * Check for snapshots, differencing disks, Hyper-V Replica's (especially initial sync on targets), dynamic disks

## Storage MB/sec

* Why: The host counters can be useful information when troubleshooting disk latency and idle time issues. For any shared storage where performance issues are being seen by any device accessing the storage, it is important to identify which host (or combination of hosts) is generating the load. Once the host has been identified, use the virtual machine counters to identify which virtual machine is generating the traffic. If it is an application or service on the host OS, stop it then contact the vendor for a fix or uninstall it - our purpose here is running virtual machines securely, fast and reliably - anything that interferes needs to be carefully evaluated.
* Threshold: no threshold - use this for getting a baseline and for capacity planning.
* Counters (Host):
  * For CSV Disks containing VM data:
    * **Cluster CSV File System(*)\IO Read Bytes/sec**
    * **Cluster CSV File System(*)\IO Write Bytes/sec**
  * For both CSV or SMB Storage:
    * **SMB Client Shares(*)\Data Bytes/sec** (Read Bytes/sec or Write Bytes/sec)
  * When local storage used for virtual machines (typically non-highly available virtual machines)
    * **LogicalDisk(*)\Disk Bytes/sec**
* Counters (VM):
  * Which virtual machines are generating most storage traffic
    * **Hyper-V Virtual Storage Device(*)\Read Bytes/sec**
    * **Hyper-V Virtual Storage Device(*)\Write Bytes/sec**

## IOPS(or equivalent):

* Why: This can be useful information when troubleshooting disk latency and idle time issues. For any shared storage where performance issues are being seen by any device accessing the storage, it is important to identify which host (or combination of hosts) is generating the load. Storage teams also like to use these numbers for comparison purposes.
* Threshold: no threshold - use this for getting a baseline and for capacity planning.
* Counter (Host):
  * For CSV Disks containing VM data:
    * **Cluster CSV File System(*)\IO Reads/sec**
    * **Cluster CSV File System(*)\IO Writes/sec**
  * For both CSV or SMB Storage:
    * **SMB Client Shares(*)\Data Requests/sec** (Read Requests/sec / Write Requests/sec)
  * When local storage used for virtual machines (typically non-highly available virtual machines)
    * **Logical Disk(*)\Disk Transfers/sec**
* Counters (VM):
  * Which virtual machines are generating most storage traffic
    * **Hyper-V Virtual Storage Device(*)\Read Operations/sec**
    * **Hyper-V Virtual Storage Device(*)\Write Operations/sec**

As usual for any of my blog posts – if you have any feedback about any of the above, please provide it – that’s how I learn.

[Back](./index.md)
