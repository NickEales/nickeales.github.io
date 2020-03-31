---
layout: default
title:  "Hyper-V Performance – Memory"
date:   2016-11-22 12:00:00 +1000
categories: Hyper-V Performance Memory
excerpt_separator: <!--more-->
---
Memory performance in Hyper-V environments is a mix of availability, ensuring Virtual Machines have the memory they need, and NUMA memory usage.
<!--more-->
This is a continuation of a series on Hyper-V performance monitoring. The previous posts covered CPU and storage performance, This post is on Memory performance, and the remaining post will cover network performance.

## Host Available Memory

* Counter: **Hyper-V Dynamic Memory Balancer\Available Memory**
* Why: This is the memory available for virtual machine usage on a Hyper-V host, while ensuring that there is sufficient memory available for Hardware and Hyper-V management.
* Threshold: < 2GB
* What to do if threshold is breached:
  * Check for many VMs with memory pressure < 60%, if so, reduce min memory
  * Check for static memory assignment VMs that have been assigned more than needed (DM candidates?) 
  * Check Dynamic Memory is responding on virtual machines enabled for Dynamic Memory (a value for the "Average Pressure" value provides that).
  * Reduce memory usage on hosts (load balance VMs between hosts?)

## Virtual Machine Memory Pressure

* Counter: **Hyper-V Dynamic Memory VM(*)\Average Pressure**
* Threshold: Any Instance > 85% sustained > 1 min. (Note this thresholds assumes the default buffer setting of 20% - adjust this threshold on a per virtual machine basis if the buffer value is modified)
* Why: This displays the ratio of committed memory within the VM to the memory allocated to the virtual machine. This indicates whether the virtual machine has enough memory for its current needs, and values close to and over 100 indicate performance impacting page file use within the virtual machine. This value will be 0 if dynamic memory is disabled on Hyper-V 2012 R2 and earlier. 
For virtual machines using dynamic memory, Hyper-V should maintain this at "100 / (100 + (100 * Memory Buffer))" (for default buffer for 20%, target pressure is 83.3%)
* What to do if threshold is breached:
  * Check each virtual machine's max memory settings (vs how much has been allocated to the virtual machine)
  * Check overall host available memory

## Virtual Machine Allocated Memory

* Counter: **Hyper-V Dynamic Memory VM(*)\Physical Memory**
* Threshold:
  * no threshold (informational counter, used for capacity planning), or
  * (optional) if dynamic memory is enabled, then > 90% of maximum memory. This is optional due the difficulty in implementing this with VMs of different maximum values.
* Why: This displays the current amount of allocated memory for each virtual machine (this value will reduce if dynamic memory reduces the memory allocated to virtual machines). The amount of memory shown within the virtual machine (either task manager or performance monitor counters) does not reduce when the memory is reduced (through dynamic memory), and so should not be used.
* What to do if threshold is breached (if one is used):
  * identify if the dynamic memory maximum value for the virtual machine needs to be increased
  * check the memory usage by the virtual machine is expected.

## Remote NUMA Memory Node Access

* Counter: **Hyper-V Vm Vid Partition(*)\Remote Physical Pages**
* Threshold: > 100 (and increasing by at least 100/hour). Note that this value will reset if the VM is restarted or migrated to a different host.
* Why: A Non-Uniform Memory Access (NUMA) node is a physical grouping of processors and memory (on a motherboard) for performance. Accessing memory on a remote NUMA node (on the same motherboard) is slower than accessing memory in the closest NUMA node for any type of CPU processing.  A remote physical page access occurs when a virtual machine CPU core running on one physical processor accesses virtual machine memory on a remote NUMA node. Hyper-V does everything it can do to avoid this occurring by choosing which processors and sections of physical memory to allocate to virtual machines, however some configurations or levels of load can cause this to occur.
* What to do if threshold is breached:
  * Use NUMA aware applications in virtual machines with large amounts of memory.
  * Reduce the memory load on the host machine (if live migrating VMs away, prefer any VMs with this issue).
  * If one virtual machine is primarily impacted (and performance is less than expected / desired), perform an action that results in that machines physical memory being reallocated to somewhere where there is sufficient memory available for the virtual machine's memory and NUMA configuration. These actions may be live migrate that VM to a different host or power off & power on that VM.
  * Avoid using dynamic memory for large memory virtual machines (> 16 GB). Virtual machines with dynamic memory enabled present a single NUMA node to virtual machines (Hyper-V servers running 2012 R2 or earlier). This may or may not impact the performance of the virtual machine.


As usual for any of my blog posts - if you have any feedback about any of the above, please provide it - that's how I learn.
