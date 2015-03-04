#!/bin/sh
sudo dd iflag=dsync oflag=dsync if=smart210_uboot.bin of=/dev/sdb seek=1
