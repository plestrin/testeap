#!/bin/bash

if ./smap_support; then
    echo -e '\x1b[31m[-]\x1b[0m CPUID indicates that SMAP is not supported'
    exit 1
else
    echo -e '\x1b[32m[+]\x1b[0m CPUID indicates SMAP support'
fi

if [ $EUID -eq 0 ]; then
	insmod smap.ko
	if [ $(cat /dev/cr4.smap) -eq 1 ]; then
		echo -e '\x1b[32m[+]\x1b[0m SMAP is activated'
	else
		echo -e '\x1b[31m[-]\x1b[0m SMAP is not activated'
	fi
	if [ $(cat /dev/smap_test) -eq 1 ]; then
		echo -e '\x1b[31m[-]\x1b[0m user space read: SUCCESS'
	else
		echo -e '\x1b[32m[+]\x1b[0m user space read: FAILURE'
	fi
	rmmod smap.ko
else
	echo -e '\x1b[33m[~]\x1b[0m script is not run by root, unable to load SMAP module'
fi

echo 'To enable / disable SMAP add / remove "nosmap" to the kernel command line'