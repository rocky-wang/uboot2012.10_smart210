#!/bin/sh
#./mkv210 u-boot.bin u-boot.16k
./tools/mk210_header u-boot.bin u-boot.16k.bin
sudo dd iflag=dsync oflag=dsync if=u-boot.16k.bin of=/dev/sdb seek=1
sudo dd iflag=dsync oflag=dsync if=u-boot.bin of=/dev/sdb seek=49
