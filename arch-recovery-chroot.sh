#!/bin/bash

# Function to list all block drive locations in /dev/ and drive names
list_drives() {
  echo "List of drives in /dev/:"
  ls -l /dev/ | grep '^b' | awk '{print $9}'
}

list_drives
echo "Please select a drive to open. SATA /dev/sdX - NVME nvmeXnXp."
read drive

# Detect the drive format
if [ -b "$drive" ]; then
  echo "The format of $drive is: $(blkid -o value -s TYPE $drive)"
else
  echo "Error: $drive is not a valid block device!"
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

sudo arch-chroot /mnt

