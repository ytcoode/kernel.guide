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
    -device nvme,serial=deadbeef,bus=rp1,drive=nvme0n1
    -blockdev driver=file,filename=./img/ext4.img,node-name=nvme0n1

    # vda
    -device virtio-blk-pci,drive=vda
    -blockdev driver=file,filename=./img/root.bcachefs.img,node-name=vda

    # share files between host and guest
    -device virtio-9p-pci,fsdev=fsdev1,mount_tag=shared
    -fsdev local,path=./shared,security_model=none,id=fsdev1

    # uefi
    -drive file=./uefi/OVMF_CODE.fd,if=pflash,format=raw,readonly=on
    -drive file=./uefi/OVMF_VARS.fd,if=pflash,format=raw

    # kernel
    -kernel ~/linux/arch/x86/boot/bzImage
    -append "root=/dev/vda rw console=ttyS0 $*"

    # misc
    -nographic
    # -s \
    # -S \
)

# run qemu command
qemu-system-x86_64 "${options[@]}"
