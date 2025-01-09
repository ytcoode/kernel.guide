#!/usr/bin/env bash

# Change to the directory where the script resides
cd "$(dirname "$0")"

# kernel command line parameters
kernel_cmdline="console=ttyS0 nokaslr $*"

if [ "${QUICK}" != "1" ]; then
    kernel_cmdline="root=/dev/vda rw ${kernel_cmdline}"
fi

# run qemu command
qemu-system-x86_64 \
    -machine q35 \
    -cpu host \
    -accel kvm \
    -smp cpus=3,maxcpus=4,sockets=2,cores=2,threads=1 \
    -m 3G,slots=1,maxmem=4G \
    -object memory-backend-ram,size=1G,id=m0 \
    -object memory-backend-ram,size=1G,id=m1 \
    -object memory-backend-ram,size=1G,id=m3 \
    -numa node,nodeid=0,memdev=m0 \
    -numa node,nodeid=1,memdev=m1 \
    -numa node,nodeid=2 \
    -numa node,nodeid=3,memdev=m3 \
    -numa cpu,node-id=0,socket-id=0,core-id=0,thread-id=0 \
    -numa cpu,node-id=1,socket-id=0,core-id=1,thread-id=0 \
    -numa cpu,node-id=2,socket-id=1,core-id=0,thread-id=0 \
    -numa cpu,node-id=3,socket-id=1,core-id=1,thread-id=0 \
    -virtfs local,path=./mnt,mount_tag=mnt,security_model=none \
    -drive file=./uefi/OVMF_CODE.fd,if=pflash,format=raw,readonly=on \
    -drive file=./uefi/OVMF_VARS.fd,if=pflash,format=raw \
    -drive file=./root.img,if=virtio,format=raw \
    -kernel ~/linux/arch/x86/boot/bzImage \
    -append "${kernel_cmdline}" \
    -nographic \
    # -s \
    # -S \
