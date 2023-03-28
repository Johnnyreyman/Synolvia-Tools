#!/bin/bash
# Password reset script for linux.
sudo sfdisk -l
echo "Which device is the Windows device?"
read dev
sudo mount $dev /mnt/Windows-Drive
cd /mnt/Windows-Drive/Windows/System32/config/
sudo chntpw -i SAM
echo "Which username would you like to reset the password of?"
read user
sudo chntpw -u $user SAM

