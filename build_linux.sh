#!/bin/bash

# from https://jootamam.net/howto-initramfs-image.htm

set -exuo pipefail

my_dir="$(cd $(dirname $0) && pwd)"

function clone_linux {
    git clone --recursive $linux_repo $linux_dir
}
function build_linux {
    (cd $linux_dir; 
        make defconfig; 
        make -j$(nproc) bzImage)
}
function copy_resultant_kernel {
    cp $kernel_path $output_dir
}


work_dir=$my_dir/work
misc_dir=$my_dir/misc
output_dir=$my_dir/output
linux_repo="https://github.com/torvalds/linux"
linux_dir=$work_dir/linux
kernel_path=$linux_dir/arch/x86/boot/bzImage

mkdir -p $work_dir $output_dir

clone_linux
build_linux
copy_resultant_kernel
