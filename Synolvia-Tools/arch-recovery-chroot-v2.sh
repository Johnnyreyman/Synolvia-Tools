#!/bin/bash

echo "Please select a drive to open. SATA /dev/sdX - NVME nvmeXnXp."
read drive

# Detect the drive format
if [ -b "$drive" ]; then
  echo "The format of $drive is: $(blkid -o value -s TYPE $drive)"
else
  echo "Error: $drive is not a valid block device!"
fi

# Detect the partition type
if [ -b "$drive'1'" ]; then
  echo "The partition type of $drive'1' is: $(parted -l | grep 'Partition Table:' | awk '{print $3}')"
else
  echo "Error: $drive'1' is not a valid block device!"
fi

echo "Is this drive encrypted?"
read luks

if [ "$luks" == "y" ]; then
    sudo cryptsetup luksOpen $drive luks_drive
    if [ "$(blkid -o value -s TYPE $drive)" == "btrfs" ]; then
    sudo mount $drive'1' /mnt/boot/efi
    sudo mount -t btrfs --subvol=@ /dev/mapper/luks_drive /mnt
    fi
fi

if [ "$luks" == "n"]; then
    sudo mount $drive'2' /mnt
    sudo mount $drive'1' /mnt/boot/efi
fi

if [ "$(parted -l | grep 'Partition Table:' | awk '{print $3}')" != "EFI" ]; then
    sudo mount $drive'1' /mnt/boot
fi

sudo arch-chroot /mnt