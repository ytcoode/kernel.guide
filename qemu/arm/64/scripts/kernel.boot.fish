#!/usr/bin/env fish

# Change into the directory where the script is located
cd (status dirname)

# Global variables that plugins may modify
set qemu_args # all arguments passed to qemu
set qemu_machine_option_value # all values of the -machine option

# All kinds of plugins go here
source plugins/qemu/machine/virt.fish $argv

# Parse the arguments
argparse -u kernel-src= kernel-args=+ dry-run -- $argv; or return

# The kernel-src option points to the kernel source root, if it's not set, give it a default value
set -ql _flag_kernel_src; or set _flag_kernel_src ~/linux

# Add common qemu arguments
set -a qemu_args -machine (string join , $qemu_machine_option_value)
set -a qemu_args -cpu max -smp 2 -m 2g
set -a qemu_args -kernel $_flag_kernel_src/arch/arm64/boot/Image
set -a qemu_args -initrd initrd/initramfs.cpio
set -a qemu_args -append (string join ' ' rdinit=/bin/init $_flag_kernel_args)
set -a qemu_args -virtfs local,path=shared,mount_tag=shared,security_model=none
set -a qemu_args -nographic
set -a qemu_args $argv

# Assemble the final qemu command
set qemu_cmd qemu-system-aarch64 $qemu_args

# If it's a dry run, just print the qemu command and exit
if set -ql _flag_dry_run
    string escape -- $qemu_cmd | string join ' '
    return
end

# Change into the final directory
cd ..

# Execute the qemu command
exec $qemu_cmd
