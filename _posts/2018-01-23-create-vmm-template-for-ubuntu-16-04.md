---
id: 245
title: Create VMM template for Ubuntu 16.04
date: 2018-01-23T14:11:02+00:00
author: nick
layout: post
guid: https://blogs.technet.microsoft.com/neales/?p=245
permalink: /2018/01/23/create-vmm-template-for-ubuntu-16-04/
opengraph_tags:
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Create VMM template for Ubuntu 16.04" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Create VMM template for Ubuntu 16.04" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta name="twitter:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Create VMM template for Ubuntu 16.04" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Create VMM template for Ubuntu 16.04" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta name="twitter:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Create VMM template for Ubuntu 16.04" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Create VMM template for Ubuntu 16.04" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta name="twitter:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Create VMM template for Ubuntu 16.04" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Create VMM template for Ubuntu 16.04" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta name="twitter:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Create VMM template for Ubuntu 16.04" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Create VMM template for Ubuntu 16.04" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta name="twitter:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    
  - |
    <meta property="og:type" content="article" />
    <meta property="og:title" content="Create VMM template for Ubuntu 16.04" />
    <meta property="og:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta property="og:site_name" content="Nick Eales’ blog" />
    <meta property="og:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    <meta name="twitter:card" content="summary" />
    <meta name="twitter:title" content="Create VMM template for Ubuntu 16.04" />
    <meta name="twitter:url" content="https://blogs.technet.microsoft.com/neales/2018/01/23/create-vmm-template-for-ubuntu-16-04/" />
    <meta name="twitter:description" content="There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo&#039;s / mistakes Download Ubuntu 16.04 ISO Create &amp; boot a Gen 2 VM using this ISO &amp; a blank disk Follow wizard (force UEFI disks if using ..." />
    
categories:
  - Hyper-V
  - Linux
  - VMM
tags:
  - Linux
  - Ubuntu
  - VMM
---
There seems to be a lot of guidance &#8211; but none of it was clear enough for me.. these are my quick notes &#8211; sorry for any typo&#8217;s / mistakes

  * Download Ubuntu 16.04 ISO
  * Create & boot a Gen 2 VM using this ISO & a blank disk
  * Follow wizard (force UEFI disks if using  Gen2 VM, and I didn&#8217;t encrypt the disks, and be sure to install the &#8220;OpenSSH Server&#8221;) &#8211; I suggest a generic username & password &#8211; as the one used here appears to still be there after VMM template is deployed.
  * After deployment, wait for VM to boot & get it&#8217;s IP address by logging into the VM & running &#8216;ifconfig&#8217;.

  * From VMM server:

<pre>Cd "C:\Program Files\Microsoft System Center 2016\Virtual Machine Manager\agents\Linux"
c:\program files\putty\PSCP.exe *.* username@VmIp:</pre>

  * the &#8216;:&#8217; after the IP is important &#8211; specifies the location to copy the files to. without anything after the &#8216;:&#8217; it will copy it to the users&#8217; home folder
  * Then from VM:

<pre># Update with latest security & other updates
sudo apt-get update && sudo apt upgrade
# enable automatic upgrades
sudo apt install unattended-upgrades
cat &gt; 20auto-upgrades &lt;&lt; EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
EOF
sudo mv ./20auto-upgrades /etc/apt/apt.conf.d/
# install VMM agent
chmod +x install
sudo ./install ./scvmmguestagent.1.0.2.1075.x64.tar
# UEFI fix (needed for Gen 2 VMs)
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --no-nvram --removable
# install & enabled Hyper-V Integration components
sudo apt-get update && sudo apt-get install linux-tools-$(uname -r) linux-cloud-tools-$(uname -r) -y
hv_fcopy_daemon
hv_kvp_daemon
hv_set_ifconfig
hv_vss_daemon
hv_get_dns_info
# shutdown VM for VHD image. (this is also needed for IC's to start working)
sudo shutdown -h now</pre>

<div class="sitewrap">
  <div class="hfeed site wrap" id="page">
    <div id="main">
      <div class="innerwrap">
        <div class="site-content" id="primary">
          <div id="content" role="main">
            <article class=" posttitle-show introfeature post-1725 post type-post status-publish format-standard hentry category-blog category-carlos-vargas category-hyper-v category-linux tag-devops tag-hyper-v tag-ubuntu" id="post-1725"></article>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

  * Next copy VHD to VMM library
  * Set VHD OS type to Ubuntu 16.04 (64 bit)
  * Create VM template 
      * Make sure secure boot is disabled & VM Generation matches that used above.

&nbsp;

The above steps didn&#8217;t work for me when using Ubuntu 17.04