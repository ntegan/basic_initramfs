#!/bin/bash

set -euxo pipefail

my_dir="$(cd $(dirname $0) && pwd)"

function get_kernel {
    wget $kernel_url
    tar -xf $kernel_dir.tar.xz
    rm  -rf $kernel_dir.tar.xz
}

kernel_major_version=5
kernel_version=${kernel_major_version}.10.8
kernel_url=https://cdn.kernel.org/pub/linux/kernel/v${kernel_major_version}.x/linux-${kernel_version}.tar.xz
kernel_dir=linux-${kernel_version}

if [[ ! -d $kernel_dir ]]; then get_kernel; fi
# TODO install qemu bios in here
#sudo make INSTALL_MOD_PATH=/home/ntegan/basic_initramfs/dest modules_install
#cp arch/x86/boot/bzImage ../kernel
# chroot ./dest; depmod $kernel_version
# install busybox too
a=(
enabled kvm
ntegan@arch-xen ~/basic_initramfs/linux-5.10.8 (git)-[master] % cat .config | grep KVM
CONFIG_HAVE_KVM=y
# CONFIG_KVM is not set
ntegan@arch-xen ~/basic_initramfs/linux-5.10.8 (git)-[master] % cat .config | grep KVM
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
)



