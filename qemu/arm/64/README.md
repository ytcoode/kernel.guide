# qemu arm64

该目录用于创建 arm64 内核的测试环境。

## 如何使用

在构建完内核后，执行 ./scripts/kernel.boot.fish 脚本，它会通过 qemu，启动你刚构建好的 arm64 内核。

该脚本默认你的内核源码根目录为 ~/linux，可通过 --kernel-src 参数修改。

该脚本会使用 initrd/initramfs.cpio 作为启动内核的 initrd 文件。

该脚本会把 shared 目录，共享给启动的内核。

该脚本可以通过 --kernel-args 为内核指定参数。

如果想查看最终完整的 qemu 命令，执行 ./scripts/kernel.boot.fish --dry-run
