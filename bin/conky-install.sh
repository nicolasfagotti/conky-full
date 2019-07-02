#!/bin/bash

# 1. Install conky fonts
mkdir ~/.fonts
cp -a ~/Dropbox/Linux/Conky/fonts/* ~/.fonts/
sudo fc-cache -f -v

# 2. Install conky components
sudo apt-get install conky conky-all hddtemp
sudo apt-get install conky conky-all

# 3. Create conky configuration files
mkdir ~/conky-config
cp ~/Dropbox/Linux/Conky/tpl/conky-main ~/conky-config
cp ~/Dropbox/Linux/Conky/tpl/conky-music ~/conky-config

# 4. Replace placeholders
# 4.1. Replace network name
echo "\e[0;32mEnter your link name (e.g. enp0s31f6): \e[0;0m"
read linkName
sed -i -- "s|###LINK###|$linkName|g" ~/conky-config/conky-main

# 4.2. Add disk partition sections
diskPartitionTpl=""
echo "\e[0;32mEnter the disk partition paths separated by comma (e.g. /media/Datos,/media/Windows): \e[0;0m"
read diskPartitionNames
for disk in $(echo $diskPartitionNames | tr "," "\n"); do
    diskPartitionTpl="$diskPartitionTpl\$\\{goto 15\\}$disk\n\$\\{goto 15\\}\$\\{fs_used_perc $disk\\}%\$\\{goto 55\\}\$\\{fs_bar 5,205 $disk\\}\$\\{alignr\\}\$\\{fs_size $disk\\}\n"
done
sed -i -- "s|###DISK_LOOP_SECTION###|$diskPartitionTpl|g" ~/conky-config/conky-main

