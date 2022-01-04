#!/bin/bash
# Setup the Favorites List #!/bin/bash


# Install Open VM Tools and OpenSSH Server
sudo apt-get update
sudo apt-get install -y open-vm-tools open-vm-tools-desktop openssh-server 

# Use a 12 hour clock 
gsettings set org.gnome.desktop.interface clock-format '12h'

# Disable Window Animations
gsettings set org.gnome.desktop.interface enable-animations false

# Don't turn off the display or lock the system
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

# Center New Windows
gsettings set org.gnome.mutter center-new-windows true

# Silence the bell
bell_style_option="set bell-style none"
inputrc_filename="$HOME/.inputrc"

grep -q -F "$bell_style_option" $inputrc_filename
if [ $? -ne 0 ]; then
  echo $bell_style_option >> $inputrc_filename
fi

# Sudoers Group members don't need to provide a password
sudo sed -i.bak "s/^\%sudo\tALL=(ALL:ALL) ALL/\%sudo\tALL=(ALL:ALL) NOPASSWD: ALL/" /etc/sudoers

# Configure VMWare Shared Folder and Standard Local Shared Folders
shared_folder_mount_point=".host:/ /mnt/hgfs fuse.vmhgfs-fuse allow_other 0 0"
fstab_filename=/etc/fstab

sudo grep -q -F "$shared_folder_mount_point" $fstab_filename
if [ $? -ne 0 ]; then
  echo $shared_folder_mount_point | sudo tee -a $fstab_filename
  if [ ! -e /mnt/hgfs ]; then
     sudo mkdir /mnt/hgfs
  fi
  sudo mount -a
fi

if [ ! -e $HOME/sf-common ]; then
   ln -sT /mnt/hgfs/common $HOME/sf-common
fi

if [ ! -e $HOME/sf-linux ]; then 
   ln -sT /mnt/hgfs/linux  $HOME/sf-linux
fi

cp sf-linux/.dircolors $HOME/
cp sf-linux/.vimrc $HOME/

# Disable the boot splash screen it saves shortens the boot time by 15-20 seconds
# Comment out the original Line  
sudo sed -i.bak "s/^GRUB_CMDLINE_LINUX_DEFAULT=/#GRUB_CMDLINE_LINUX_DEFAULT=/" /etc/default/grub
# Insert a new line below the existing line that removes the "quiet" and/or  "splash" options
# This displays the boot process results in slightly faster boot times 
sudo sed -i.bak "/^#GRUB_CMDLINE_LINUX_DEFAULT=/aGRUB_CMDLINE_LINUX_DEFAULT=\"\"" /etc/default/grub
sudo update-grub

# Disable automatic unattendted upgrades
sudo sed -i.bak  "s/^APT::Periodic::Unattended-Upgrade \"1\"/APT::Periodic::Unattended-Upgrade \"0\"/" /etc/apt/apt.conf.d/20auto-upgrades

# Install some useful tools
sudo apt-get install -y gnome-tweaks nautilus-admin
sudo apt-get install -y vim tree tmux

## Install Alias for Python3
sudo apt-get install python-is-python3

# Fix LS_COLORS settings that are unreadable 
printf "\n\n# FIX LS_COLORS \n\nLS_COLORS=\$LS_COLORS:'ow=1;4;34;102:'\n\n" >> ~/.bashrc
