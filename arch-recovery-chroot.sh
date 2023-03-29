#!/bin/bash

lsblk -o name,type

echo "Please select a drive to open. SATA /dev/sdX - NVME nvmeXnXp."
read drive

# Verify that the user entered a valid drive name
if [ ! -b "$drive" ]; then
  echo "Error: $drive is not a valid block device!"
  exit 1
fi

# Detect the drive format
drive_type=$(blkid -o value -s TYPE "$drive")

if [ -z "$drive_type" ]; then
  echo "Error: Could not determine drive format for $drive."
  exit 1
fi

echo "Drive format: $drive_type"

echo "Is this drive encrypted?"
read luks

if [ "$luks" == "y" ]; then
  if ! command -v cryptsetup &> /dev/null; then
    echo "Error: cryptsetup is not installed."
    exit 1
  fi

  sudo cryptsetup luksOpen "$drive" luks_drive

  if [ "$drive_type" == "btrfs" ]; then
    sudo mount "${drive}1" /mnt/boot/efi
    sudo mount -t btrfs --subvol=@ /dev/mapper/luks_drive /mnt
  fi
elif [ "$luks" != "n" ]; then
  echo "Error: Invalid input for encrypted drive question."
  exit 1
else
  sudo mount "${drive}2" /mnt
  sudo mount "${drive}1" /mnt/boot/efi
fi

if ! command -v arch-chroot &> /dev/null; then
  echo "Error: arch-chroot is not installed."
  exit 1
fi

sudo arch-chroot /mnt
