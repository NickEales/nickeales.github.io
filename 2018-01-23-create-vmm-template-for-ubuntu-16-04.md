---
layout: default
date:   2018-01-23 12:00:00 +1000
categories: SCVMM Hyper-V VMM Ubuntu
excerpt_separator: <!--more-->
page.comments: true
---
# Create VMM template for Ubuntu 16.04

My personal notes for creating a Ubuntu 16.04 VMM template
<!--more-->

There seems to be a lot of guidance - but none of it was clear enough for me.. these are my quick notes - sorry for any typo's / mistakes

1. Download Ubuntu 16.04 ISO
1. Create & boot a Gen 2 VM using this ISO & a blank disk
1. Follow wizard (force UEFI disks if using  Gen2 VM, and I didn't encrypt the disks, and be sure to install the "OpenSSH Server") - I suggest a generic username & password - as the one used here appears to still be there after VMM template is deployed.
1. After deployment, wait for VM to boot & get it's IP address by logging into the VM & running 'ifconfig'.
1. From VMM server:
```
Cd "C:\Program Files\Microsoft System Center 2016\Virtual Machine Manager\agents\Linux"
c:\program files\putty\PSCP.exe *.* username@VmIp:
```
   * the ':' after the IP is important - specifies the location to copy the files to. without anything after the ':' it will copy it to the users' home folder
1. Then from VM:
```
# Update with latest security & other updates
sudo apt-get update && sudo apt upgrade
# enable automatic upgrades
sudo apt install unattended-upgrades
cat > 20auto-upgrades << EOF
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
sudo shutdown -h now
```

1. Next copy VHD to VMM library
1. Set VHD OS type to Ubuntu 16.04 (64 bit)
1. Create VM template
1. Make sure secure boot is disabled & VM Generation matches that used above.

## *Note: The above steps didn't work for me when using Ubuntu 17.04*

[Back](./index.md)
