#!/usr/bin/env bash

# Change to the directory where the script resides
cd "$(dirname "$0")"

# qemu options
options=(
    # machine
    -machine q35
    -accel kvm,kernel-irqchip=split

    # cpu
    -cpu host
    -smp cpus=3,maxcpus=4,sockets=2,cores=2

    # memory
    -m 3G,slots=1,maxmem=4G
    -object memory-backend-ram,size=1G,id=m0
    -object memory-backend-ram,size=1G,id=m1
    -object memory-backend-ram,size=1G,id=m3

    # numa
    -numa node,nodeid=0,memdev=m0
    -numa node,nodeid=1,memdev=m1
    -numa node,nodeid=2
    -numa node,nodeid=3,memdev=m3
    -numa node,nodeid=4,
    -numa cpu,socket-id=0,core-id=0,node-id=0
    -numa cpu,socket-id=0,core-id=1,node-id=1
    -numa cpu,socket-id=1,core-id=0,node-id=2
    -numa cpu,socket-id=1,core-id=1,node-id=3

    # interrupt remapping
    -device intel-iommu,intremap=on

    # pcie root ports
    -device pcie-root-port,id=rp1

    # nvme
    -blockdev driver=file,filename=./nvme.img,node-name=nvme0
    -device nvme,bus=rp1,serial=deadbeef,drive=nvme0

    # vda
    -blockdev driver=file,filename=./root.img,node-name=vda
    -device virtio-blk-pci,drive=vda

    # share files between host and guest
    -virtfs local,path=./mnt,mount_tag=mnt,security_model=none

    # uefi
    -drive file=./uefi/OVMF_CODE.fd,if=pflash,format=raw,readonly=on
    -drive file=./uefi/OVMF_VARS.fd,if=pflash,format=raw

    # kernel
    -kernel ~/linux/arch/x86/boot/bzImage
    -append "root=/dev/vda rw console=ttyS0 debug $*"

    # misc
    -nographic
    # -s \
    # -S \
)

# run qemu command
qemu-system-x86_64 "${options[@]}"
