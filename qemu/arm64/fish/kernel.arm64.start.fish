function kernel.arm64.start
    qemu-system-aarch64 \
        -machine virt,virtualization=on,gic-version=max \
        -cpu max -smp 2 -m 2g \
        -device pcie-root-port,id=rp0,slot=0 \
        -device pcie-root-port,id=rp1,slot=1 \
        -device x3130-upstream,id=up0,bus=rp0 \
        -device xio3130-downstream,id=dp0,slot=2,bus=up0 \
        -device xio3130-downstream,id=dp1,slot=3,bus=up0 \
        -device nvme,serial=deadbeef,drive=nvme0n1,bus=dp0 \
        -blockdev driver=file,filename=$HOME/qemu/img/ext4.img,node-name=nvme0n1 \
        -virtfs local,path=$HOME/qemu/mnt,mount_tag=mnt,security_model=none \
        -kernel ~/linux/arch/arm64/boot/Image \
        -initrd ~/qemu/arm64/initramfs.cpio \
        -append "rdinit=/bin/init console=ttyAMA0 debug" \
        -nographic
end
