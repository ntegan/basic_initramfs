#!/bin/bash



qemu-system-x86_64 -enable-kvm -smp 4 -m 4G \
    -kernel output/bzImage \
    -initrd output/initramfs.igz \
    -append 'console=ttyS0 root=/dev/sda' \
    -nic user \
    -hda output/rootfs \
    -nographic

