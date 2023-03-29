#!/bin/bash
sudo cryptsetup luksOpen /dev/nvme0n1p2 enterprise
cd /mnt
sudo mount -t btrfs -o subvol=@ /dev/mapper/enterprise /mnt
sudo mkdir boot/efi
sudo mount /dev/nvme0n1p1 /boot/efi
sudo arch-chroot /mnt