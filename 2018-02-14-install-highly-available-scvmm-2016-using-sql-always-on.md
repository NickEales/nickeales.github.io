---
layout: default
date:   2018-02-14 12:00:00 +1000
categories: SCVMM Hyper-V VMM
excerpt_separator: <!--more-->
---
# Install highly available SCVMM 2016 using SQL Always On

One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we used.
<!--more-->

## Assumptions

* Operating systems are already installed on at least four machines (SqlNode1, SqlNode2, VmmNode1, VmmNode2)
* Failover Clustering is configured so that SqlNode1 and SqlNode2 are in one cluster and VmmNode1 and VmmNode2 are in a different cluster.
* SQL Enterprise is installed and configured with always on capability enabled and a listener configured (SqlFMList). In our case, the listener was configured to listen on port 1771. SQL must be using port 1433 for a non-always on instance / database for this to work

## The installation steps we used

1. Create the VMMService account (eg svc_vmmservice), and grant it permissions to
    * SQL on SqlNode1
    * Local administrator group on  VmmNode1 and VmmNode2
2. Install VMM on VmmNode1. When you get to the SQL configuration section, give the computer name SqlNode1, port 1433, and allow it to create the database (VirtualManagerDB). Note down the location of the DKM.
3. Uninstall VMM, choosing the option to retain the database.
4. Ensure the svc_vmmservice account has a db_owner permissions of the VMM database.
5. Ensure the SQL Listener / AG is active on the node that has the Database, but do not add the database to the Always On group yet.
6. Use the below ini file to install VMM on one VMM node at a time -  (we couldn't get this to work using the graphical installer due to the SQL port required and issues with the user interface). This will install VMM so that when launching the console, connect to the address "vmm:8100"

```
[OPTIONS]
ProductKey=XXXXXXXXXXXX
UserName=Name
CompanyName=Name
ProgramFiles=C:\Program Files\Microsoft System Center 2016\Virtual Machine Manager
CreateNewSqlDatabase=0
SqlDatabaseName=VirtualManagerDB
SqlServerPort=1771
RemoteDatabaseImpersonation=0
SqlMachineName=SqlFMList
IndigoTcpPort=8100
IndigoHTTPSPort=8101
IndigoNETTCPPort=8102
IndigoHTTPPort=8103
WSManTcpPort=5985
BitsTcpPort=443
#CreateNewLibraryShare=1
#LibraryShareName=MSSCVMMLibrary
#LibrarySharePath=D:\VMMLIB\
#LibraryShareDescription=Virtual Machine Manager Library Files
SQMOptIn = 0
MUOptIn = 0
VmmServiceLocalAccount = 0
TopContainerName="CN=DKM,DC=LAB,DC=INTRANET" #replace this with the DKM location
HighlyAvailable = 1
VmmServerName=VMM
VMMStaticIPAddress=10.51.83.236
Upgrade=0
```

The command line used to use this INI file is:

```
setup.exe /server /i /f <IniFilePath> /VmmServiceDomain <Domain> /VmmServiceUserName <Service Account> /VmmServiceUserPassword <Service account PW> /IACCEPTSCEULA
```

After installation of VMM on both nodes, check the VMM console can connect to the server
Using cluster manager take the VMM service offline
Add the SQL database to the AG with the listener used in the above file (SqlFMList).
Restart VMM. Check that VMM works with different combinations of which node VMM & SQL are on.

The "Upgrade" setting in the ini file - is set to zero because in the initial installation to create the database, my customer also applied UR4. By default the installation appears to try to "upgrade" the database version if the versions don't match the expected version (2016 RTM) - since we were using a newer version, we had to tell it not to upgrade it.

[Back](./index.md)
