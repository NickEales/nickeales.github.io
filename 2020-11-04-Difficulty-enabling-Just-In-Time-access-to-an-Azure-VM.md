---
layout: index
date:   2020-11-04 12:00:00 +1000
---
# Difficulty enabling Just In Time access to an Azure VM

I recently had to enable JIT on a VM & ran into some errors that I couldn't find help on.

These were found in the Activity log for the VM under the operation "Create or Update JIT Network Access Policy" and were:

- "Virtual machine is missing associated Jit network resources"
- "network resources configuration failure"

In my case - this was simply due to the VM not having an existing NSG on the Network interface.

[Back](./index.md)