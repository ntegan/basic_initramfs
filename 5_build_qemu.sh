#!/bin/bash

set -euxo pipefail

my_dir="$(cd $(dirname $0) && pwd)"

function get_qemu {
    cd $my_dir
    qemu_archive=$qemu_dir.tar.xz
    qemu_download=https://download.qemu.org/$qemu_archive

    wget $qemu_download
    tar -xf $qemu_archive
    rm $qemu_archive
}
function make_docker_image {
    make -C $my_dir/$qemu_dir docker-image-debian-amd64
}
function build {
    configure_args=(
        --target-list=x86_64-softmmu \
        --audio-drv-list="" \
        --disable-libudev \
        --enable-kvm \
        --disable-xen \
        --disable-xen-pci-passthrough \
        --disable-werror \
        --disable-sdl \
        --disable-gtk \
        --disable-fdt \
        --disable-libusb \
        --disable-slirp \
        --disable-docs \
        --disable-vhost-net \
        --disable-spice \
        --disable-guest-agent \
        --disable-smartcard \
        --disable-vnc \
        --disable-spice \
        --disable-gnutls \
        --disable-nettle \
        --disable-gcrypt \
        --disable-vte \
        --disable-curses \
        --disable-cocoa \
        --disable-virtfs \
        --disable-brlapi \
        --disable-curl \
        --disable-rdma \
        --disable-vde \
        --disable-netmap \
        --disable-linux-aio \
        --disable-cap-ng \
        --disable-attr \
        --disable-rbd \
        --disable-libiscsi \
        --disable-libnfs \
        --disable-usb-redir \
        --disable-lzo \
        --disable-snappy \
        --disable-bzip2 \
        --disable-seccomp \
        --disable-coroutine-pool \
        --disable-glusterfs \
        --disable-tpm \
        --disable-libssh \
        --disable-numa \
        --disable-tcmalloc \
        --disable-jemalloc \
        --disable-vhost-scsi \
        --disable-qom-cast-debug \
        --disable-virglrenderer \
        --disable-tools \
        --disable-replication \
        --disable-vhost-vsock \
        --disable-hax \
        --disable-vhost-vsock \
        --disable-opengl \
        --disable-virglrenderer \
        --disable-xfsctl \
        --disable-blobs \
        --disable-tcg \
        --disable-crypto-afalg \
        --disable-live-block-migration \
        --disable-vhost-user \
        --disable-vhost-crypto \
        --disable-vdi \
        --disable-bochs \
        --disable-cloop \
        --disable-dmg \
        --disable-qcow1 \
        --disable-parallels \
        --disable-vvfat \
        --disable-qed \
        --disable-sheepdog \
        --disable-auth-pam \
        --cxx=/non-existent \
        --prefix=/usr
    )
    build_command="cd /source/$qemu_dir; "
    build_command+="./configure ${configure_args[@]}; "
    build_command+="mkdir /source/dest; "
    build_command+="make -j$(nproc) DESTDIR=/source/dest install; "
    build_command+="make distclean; "
    build_command+="chown -R $USER /source; "
    docker run -it --rm \
        -v "$(pwd)":/source \
        --workdir /source \
        $build_container bash -c "$build_command"
}
function lookup_dependencies {
    set +x
    things=()
    while read -r line; do
        things+=(" $(echo $line | awk '{print $1}')")
    done<<<"$(ldd $my_dir/dest/usr/bin/qemu-system-x86_64)"
    set -x
    echo ${things[@]}
}
function make_rootfs {
    couldnt_find=(
    linux-vdso.so.1
    #libudev.so.1
    # uh oh, it's in systemd-libs
    )
    could_find=(
    libpixman-1.so.0
    libz.so.1
    libgio-2.0.so.0
    libgobject-2.0.so.0
    libglib-2.0.so.0
    libutil.so.1
    libm.so.6
    libpthread.so.0
    libc.so.6
    /lib64/ld-linux-x86-64.so.2
    libgmodule-2.0.so.0
    libmount.so.1
    libresolv.so.2
    libffi.so.7
    libpcre.so.1
    libdl.so.2
    libblkid.so.1
    librt.so.1
    )
    packages=(
    pixman
    zlib
    glib2
    glibc
    util-linux
    util-linux-libs
    libffi
    pcre
    )
    mkdir -p $my_dir/dest/var/lib/pacman
    sudo pacman -r $my_dir/dest -Sy ${packages[@]}

    cp $my_dir/misc/init_template2 $my_dir/dest/init
}

qemu_version=5.2.0
qemu_dir=qemu-$qemu_version
build_container=qemu/debian-amd64

if [[ ! -d $qemu_dir ]]; then get_qemu; fi
if ! docker image inspect $build_container 1>/dev/null 2>&1; then make_docker_image; fi
if [[ ! -d $my_dir/dest ]]; then build; fi
# TODO add dependencies
# TODO how did i disable installation of option/pc-bios/linnux-load roms?
#lookup_dependencies
#make_rootfs

