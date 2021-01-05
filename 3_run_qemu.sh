#!/bin/bash



qemu-system-x86_64 -enable-kvm -smp 4 -m 4G \
    -kernel output/bzImage \
    -initrd output/initramfs.igz \
    -append 'console=ttyS0 root=/dev/sda' \
    -netdev user,id=n1 \
    -device e1000,netdev=n1 \
    -hda output/rootfs \
    -nographic

