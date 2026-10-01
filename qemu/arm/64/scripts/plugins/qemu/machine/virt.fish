set -a qemu_machine_option_value virt
set -a qemu_machine_option_value virtualization=on
set -a qemu_machine_option_value gic-version=max

argparse dumpdtb -- $argv; or return

if set -ql _flag_dumpdtb
    set -a qemu_machine_option_value dumpdtb=qemu.dtb
end
