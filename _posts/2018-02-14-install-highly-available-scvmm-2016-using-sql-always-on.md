---
id: 265
title: Install highly available SCVMM 2016 using SQL Always On
date: 2018-02-14T13:14:24+00:00
author: nick
layout: post
guid: https://blogs.technet.microsoft.com/neales/?p=265
permalink: /2018/02/14/install-highly-available-scvmm-2016-using-sql-always-on/
opengraph_tags:
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Install highly available SCVMM 2016 using SQL Always On" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/02/14/install-highly-available-scvmm-2016-using-sql-always-on/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Install highly available SCVMM 2016 using SQL Always On" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/02/14/install-highly-available-scvmm-2016-using-sql-always-on/" />
    <meta name="twitter:description" content="One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Install highly available SCVMM 2016 using SQL Always On" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/02/14/install-highly-available-scvmm-2016-using-sql-always-on/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Install highly available SCVMM 2016 using SQL Always On" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/02/14/install-highly-available-scvmm-2016-using-sql-always-on/" />
    <meta name="twitter:description" content="One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Install highly available SCVMM 2016 using SQL Always On" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/02/14/install-highly-available-scvmm-2016-using-sql-always-on/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Install highly available SCVMM 2016 using SQL Always On" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/02/14/install-highly-available-scvmm-2016-using-sql-always-on/" />
    <meta name="twitter:description" content="One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Install highly available SCVMM 2016 using SQL Always On" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/02/14/install-highly-available-scvmm-2016-using-sql-always-on/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Install highly available SCVMM 2016 using SQL Always On" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/02/14/install-highly-available-scvmm-2016-using-sql-always-on/" />
    <meta name="twitter:description" content="One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we..." />
    
categories:
  - VMM
tags:
  - VMM
---
One of my customers recently had a frustrating time installing a VMM 2016 in a highly available configuration when using SQL Always on for the database. A standalone install into a highly available virtual machine does not meet their requirements. Due to the frustrations with getting this to work, I am sharing the steps we used.  
&nbsp;

<p style="margin: 0in;font-family: Calibri;font-size: 11.0pt">
  Assumptions:
</p>

  * Operating systems are already installed on at least four machines (SqlNode1, SqlNode2, VmmNode1, VmmNode2)
  * Failover Clustering is configured so that SqlNode1 and SqlNode2 are in one cluster and VmmNode1 and VmmNode2 are in a different cluster.
  * SQL Enterprise is installed and configured with always on capability enabled and a listener configured (SqlFMList). In our case, the listener was configured to listen on port 1771. SQL must be using port 1433 for a non-always on instance / database for this to work

&nbsp;

<p style="margin: 0in;font-family: Calibri;font-size: 11.0pt">
  The installation steps we used
</p>

  1. Create the VMMService account (eg svc_vmmservice), and grant it permissions to 
      * SQL on SqlNode1
      * Local administrator group on  VmmNode1 and VmmNode2
  2. Install VMM on VmmNode1. When you get to the SQL configuration section, give the computer name SqlNode1, port 1433, and allow it to create the database (VirtualManagerDB). Note down the location of the DKM.
  3. Uninstall VMM, choosing the option to retain the database.
  4. Ensure the svc\_vmmservice account has a db\_owner permissions of the VMM database.
  5. Ensure the SQL Listener / AG is active on the node that has the Database, but do not add the database to the Always On group yet.
  6. Use the below ini file to install VMM on one VMM node at a time &#8211;  (we couldn&#8217;t get this to work using the graphical installer due to the SQL port required and issues with the user interface). This will install VMM so that when launching the console, connect to the address &#8220;vmm:8100&#8221;

<pre style="margin: 0in;margin-left: .375in;font-family: Calibri;font-size: 11.0pt">[OPTIONS]
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
Upgrade=0</pre>

&nbsp;

<p style="margin: 0in;font-family: Calibri;font-size: 11.0pt">
  The command line used to use this INI file is:
</p>

<pre style="margin: 0in;font-family: Calibri;font-size: 11.0pt;color: #262626">setup.exe /server /i /f &lt;IniFilePath&gt; /VmmServiceDomain &lt;Domain&gt; /VmmServiceUserName &lt;Service Account&gt; /VmmServiceUserPassword &lt;Service account PW&gt; /IACCEPTSCEULA</pre>

&nbsp;

<ol start="7">
  <li>
    After installation of VMM on both nodes, check the VMM console can connect to the server
  </li>
  <li>
    Using cluster manager take the VMM service offline
  </li>
  <li>
    Add the SQL database to the AG with the listener used in the above file (SqlFMList).
  </li>
  <li>
    Restart VMM. Check that VMM works with different combinations of which node VMM & SQL are on.
  </li>
</ol>

&nbsp;  
The &#8220;Upgrade&#8221; setting in the ini file &#8211; is set to zero because in the initial installation to create the database, my customer also applied UR4. By default the installation appears to try to &#8220;upgrade&#8221; the database version if the versions don&#8217;t match the expected version (2016 RTM) &#8211; since we were using a newer version, we had to tell it not to upgrade it.