#!/bin/bash
sudo cryptsetup luksOpen /dev/nvme0n1p2 enterprise
cd /mnt2
sudo mount -t btrfs -o subvol=@ /dev/mapper/enterprise /mnt2
sudo mkdir /mnt2/boot/efi
sudo mount /dev/nvme0n1p1 /boot/efi
sudo arch-chroot /mnt2