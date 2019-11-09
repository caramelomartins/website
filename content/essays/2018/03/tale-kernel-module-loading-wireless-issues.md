---
title: "A Tale of Kernel Module Loading and Wireless Issues"
date: 2018-03-21T00:00:00+01:00
draft: false
summary: Recently, I have had to reinstall my OS (Ubuntu) several times due to a mix of filesystem and HDD corruption issues. This, invariably, has led me to a situation where Asus K450J's wireless networking doesn't work.
categories:
    - kernel
---

Recently, I have had to reinstall my OS (Ubuntu) several times due to a mix of filesystem and HDD corruption issues. This, invariably, has led me to a situation where Asus K450J's wireless networking doesn't work. My go to solution, so far, has been to look into an answer [1] in StackOverflow and fix the issue with the solution proposed. I have never given too much thought why this happens, or why the solutions resolves it, but it is intriguing that there are no explanations on the answer. The answer has no votes, wasn't accepted and had no comments on it, which sparked my interest even further. Why does this work?!

## Solution

The solution, presented in the answer, is the following block of code:

```
sudo tee /etc/modprobe.d/blacklist-acer.conf <<< "blacklist acer_wmi"
```

Run this on the terminal, reboot laptop and we are done.

## Deconstructing

Starting with the easier part of it, there are 2 clear commands on this answer:

- `sudo`;
- `tee`.


From `sudo`'s man page [2], we conclude the following:

> **sudo** allows a permitted user to execute a *command* as the superuser or another user, as specified by the security policy.

Since the command doesn't refer any other user, we can safely assumed that we are running the command as the superuser. This makes sense since, at least on Ubuntu's fresh installation, `/etc` is a directory not writable by any and every user. `tee` is just a simple program that allows standard input (`STDIN`) to be redirected to standard output (`STDOUT`) and, at the same time, to send that output to some files. This can be easily confirmed in `tee`'s man page [3]. So far it has been fairly easy and straightforward.

The argument that is passed to `tee` is for the file `/etc/modprobe.d/blacklist-acer.conf`. What is this file and why might we care writing to it? A quick read over [The Linux Documentation Project](https://www.tldp.org/)'s pages [4] makes me conclude that `/etc` is mostly a directory where files, that several programs use, are stored. So...what program uses the `/etc/modprobe.d/` directory? As it might seem obvious by now, specially after reading TLDP's pages, the program that uses this directory is `modprobe` [5], which can be used "to add or remove modules from the Linux Kernel" [6]. By reading [5] again, I figure out that writing `blacklist acer_wmi` tells `modprobe` to ignore this module. Tthe reasons for that are also described, in the documentation (*emphasis mine*):

> Modules can contain their own aliases: usually these are aliases describing the devices they support, such as "pci:123...". These "internal" aliases can be overridden by normal "alias" keywords, but **there are cases where two or more modules both support the same devices, or a module invalidly claims to support a device**: the blacklist keyword indicates that all of that particular module's internal aliases are to be ignored

At this point I start to become suspicious that `acer_wmi` is a Linux Kernel module that messes up Asus' wireless configuration on a Ubuntu's fresh installation, by claiming to support a device that it really doesn't support. Another user, using a Lenovo Thinkpad E420 claims similar issues on Ubuntu 11.10 [7], on the grounds that:

>  The only glitch is **the wifi drivers which don’t run by default**, and it could be corrected easily

Another article also seems to point towards issues with `acer_wmi` [8]:

> A certain kernel module, called acer_wmi, causes problems on some laptops. Because it has been loaded when it shouldn't have been.

I have found other occurrences of this problem, in different laptops both from Lenovo and Asus. Which leads me to question: why is `acer_wmi` loaded by default?

## Why?

By reading the `acer-wmi.txt` [9], which is a sort of `README` of the `acer-wmi.c`  Linux kernel module [10], it says: _"On Acer laptops, acer-wmi should already be autoloaded based on DMI matching."_ Now, using this line of thinking, we have to look up what _"DMI matching"_ actually stands for. Searching the Linux mailing list, we find a 2007 patch [11] that enabled _"DMI-based module autoloading"_ with the following explanation:

> The patch below adds DMI/SMBIOS based module autoloading to the Linux kernel. The idea is to load laptop drivers automatically (and other drivers which cannot be autoloaded otherwise), based on the DMI system identification information of the BIOS.

Interesting. Let's look up what the DMI for my Asus laptop looks like (BIOS-wise):

```
BIOS Information
        Vendor: American Megatrends Inc.
        Version: 216

(...)

System Information
        Manufacturer: ASUSTeK COMPUTER INC.
        Product Name: X450JF
        Version: 1.0
(...)
        BIOS Revision: 4.6

(...)
```

I redacted a **lot** of information to keep this simple. So, clearly my manufacturer is Asus and my model is X450JF...why would the kernel load up an Acer module?

Listing loaded modules, and searching for Asus drivers, using `lsmod | grep asus` returns:

```
asus_nb_wmi            28672  0
asus_wmi               28672  1 asus_nb_wmi
sparse_keymap          16384  1 asus_wmi
asus_wireless          16384  0
wmi                    24576  4 asus_wmi,wmi_bmof,mxm_wmi,nouveau
video                  40960  3 asus_wmi,nouveau,i915
```

So...Asus drivers are currently being loaded, which means they _can_ be loaded, but why were the Acer ones selected to begin with? I have no idea.

For now, that's okay. I have understood the high-level reason why it wasn't working in the first place. I don't really know why the kernel loads up the wrong module but, by looking at both modules' code, they have very different approaches to verifying what type of machine it's dealing with.

## Conclusion

What started out as an investigation into a simple command-line expression, ended up being a fun investigation into the surface of kernel module loading. I didn't find exactly the reason why it loads the incorrect module but, from searching, I see that this is an issue which has an open (although expired) bug in the Linux bug tracker.

## References

[1] https://askubuntu.com/questions/879581/wi-fi-does-not-work-on-asus-k450j

[2] https://www.sudo.ws/man/1.8.3/sudo.man.html

[3] http://man7.org/linux/man-pages/man1/tee.1.html

[4] https://www.tldp.org/LDP/sag/html/etc-fs.html

[5] https://linux.die.net/man/5/modprobe.d

[6] https://linux.die.net/man/8/modprobe

[7] https://exain.wordpress.com/2011/10/16/wireless-on-ubuntu-11-10-and-lenovo-thinkpad-e420/

[8] https://sites.google.com/site/easylinuxtipsproject/internet#TOC-Turn-the-kernel-module-acer_wmi-off

[9] https://github.com/spotify/linux/blob/master/Documentation/laptops/acer-wmi.txt

[10] https://github.com/torvalds/linux/blob/master/drivers/platform/x86/acer-wmi.c

[11] https://lwn.net/Articles/233385/