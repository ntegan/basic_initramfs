##  Intro
This repo contains scripting that lays out the process
of building an initramfs, kernel, and root filesystem
from (pretty much) scratch.

The resulting triplet of (initramfs,kernel,rootfs) is
booted using qemu for testing.

Can probably clone and run `make all` to build the three,
and then `make run` to run in qemu.

## Dependencies
* Docker
* sudo
* wget
* git
* qemu

`base-devel` or `build-essential`

## Build a Busybox initramfs
`0_build_initramfs.sh` contains the implementation of
creating an initramfs from a downloaded statically compiled
Busybox binary.

## Build a root filesystem
`1_build_rootfs.sh` runs the archlinux docker container
in order to create an archlinux base installation/root
file system for the initramfs to switch to during
the early boot process.

## Building the linux kernel
`2_build_kernel.sh` clones Linux from Torvalds' github
page, builds a `bzImage` with `defconfig` and places it
in this repo's output folder.

Note, cloning the whole linux repo takes forever.
You can get your own kernel/bzImage and put it in `output`
to skip this step.

## Running the build images
`3_run_qemu.sh` will boot a qemu/kvm guest in your terminal
window and boot into the build initramfs+kernel+rootfs.
Login to `root` user.

Basic networking and editing with `vim` is available.

## TODO
setup the archlinux rootfs with locale and such

Might be the reason why can't

`man systemd` or `man systemd.network` inside the guest.

### Also
can't do this in a chroot, so have to do it once booted in qemu
```
pacman-key --init
pacman-key --populate
```
