#!/bin/sh
qemu-system-x86_64 -enable-kvm -daemonize \
    -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
    -smp cores=1 \
    -m 256M \
    -vga qxl \
    -drive file=$PWD/images/floppy.img,if=floppy,format=raw \
    -boot a \
    "$@"
 
