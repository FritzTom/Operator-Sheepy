#!/bin/bash

cd ..


nasm -f bin source/main.asm -o binaries/main.bin

cd binaries


dd if=/dev/zero of=null.bin bs=512 count=20

cat main.bin null.bin > disk.bin

qemu-system-x86_64 disk.bin