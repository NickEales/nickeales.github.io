---
layout: default
date:   2020-03-31 12:00:00 +1000
---
# Allow Azure VM to activate using Azure KMS when using Azure Firewall

## assumptions

1. routing within the vNet (by UDR or other) directs traffic destined for Azure KMS to the Azure Firewall.
2. Azure VM is running a supported Windows version that can activate with Azure's KMS server.

This is being documented mostly to point out that you need to use a Network Rule, not an Application Rule. Application rules only work for the HTTP & HTTPS protocols, and KMS does not use these.

## steps

This is the network rule that allows outbound access to Azure KMS server.

Select the Network rule collection tab.

1. Select Add network rule collection.
2. For Name, type AzureKMS.
3. For Priority, type 200. (or pick another number that is not in use and lower then any Deny rules that would cover this traffic)
4. For Action, select Allow.
5. Under Rules, IP addresses, for Name, type Allow-KMS.
6. For Protocol, select TCP.
7. For Source type, select IP address.
8. For Source, type 10.0.2.0/24. <-- replace this with the IP range of your vNet
9. For Destination address, type 23.102.135.246
10. This is the Azure KMS server's IP.
11. For Destination Ports, type 1688.
12. Select Add.

if there is demand, let me know and I'll add screenshots.

[Back](./index.md)