#!/usr/bin/env bash

arm-none-eabi-as -o startup.o startup.s
#fgr arm-none-eabi-gcc -c -nostdlib -nostartfiles -o cstart.o cstart.c
#fgr arm-none-eabi-g++ -c -std=c++2a -fno-exceptions -fno-non-call-exceptions -fno-rtti -ffreestanding -fno-common -ffunction-sections -fdata-sections -nostartfiles -o cppstart.o cppstart.cpp
arm-none-eabi-g++ -c -std=c++2a -fno-exceptions -fno-non-call-exceptions -fno-rtti -ffreestanding -fno-common -nostartfiles -o cppstart.o cppstart.cpp
arm-none-eabi-ld -T linkscript.ld -o cppenv.elf startup.o cppstart.o
arm-none-eabi-objcopy -O binary cppenv.elf cppenv.bin

make -C ../common_uboot/ vexpress_ca9x4_config ARCH=arm CROSS_COMPILE=arm-none-eabi-
make -C ../common_uboot/ all ARCH=arm CROSS_COMPILE=arm-none-eabi-

#../common_uboot/tools/mkimage -A arm -C none -T kernel -a 0x60000000 -e 0x60000000 -d cppenv.elf bare-arm.uimg
../common_uboot/tools/mkimage -A arm -C none -T kernel -a 0x60000000 -e 0x60000000 -d cppenv.bin bare-arm.uimg
./create-sd.sh sdcard.img bare-arm.uimg
