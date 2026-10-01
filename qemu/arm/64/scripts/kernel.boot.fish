#!/usr/bin/env fish

cd (status dirname)

# global variables that plugins may modify
set qemu_args # all arguments passed to qemu
set qemu_machine_option_value # all values of the -machine option

# all kinds of plugins go here
source plugins/qemu/machine/virt.fish $argv

#
set -a qemu_args -machine (string join , $qemu_machine_option_value)
set -a qemu_args -cpu max -smp 2 -m 2g
set -a qemu_args -kernel linux/arch/arm64/boot/Image
set -a qemu_args -initrd initrd/initramfs.cpio
set -a qemu_args -append (string join ' ' rdinit=/bin/init $_flag_kernel_args)
set -a qemu_args -nographic
set -a qemu_args -virtfs local,path=$qemu_dir_arm64/shared,mount_tag=shared,security_model=none
set -a qemu_args $argv

#
cd ..

echo $qemu_machine_option_value
