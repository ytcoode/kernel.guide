#!/usr/bin/env fish

cd (status dirname)
cd initramfs

fd --unrestricted | cpio -ov -H newc >../initramfs.cpio
