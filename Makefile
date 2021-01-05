kernel=output/bzImage
initramfs=output/initramfs.igz
rootfs=output/rootfs



$(initramfs):
	bash ./0_build_initramfs.sh
$(rootfs):
	bash ./1_build_rootfs.sh
$(kernel):
	bash ./2_build_kernel.sh
run_qemu:
	bash ./3_run_qemu.sh
do_clean:
	bash ./4_clean.sh

all: $(kernel) $(initramfs) $(rootfs)
run: run_qemu
clean: do_clean
