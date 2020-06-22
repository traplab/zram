ZRAM MODULE

--> Author <--
Traplab

Zram module implements RAM storage rather that disk storage
Pros: Faster

Advisable 75% of RAM is advised.
Only 1% of swap is oftenly used


The script will deactivate your previous swap allocation by swapoff and in fstab
Backup /etc/fstab...just incase
Create zram module,allocate space,create necessary scripts and service files for persistence



files:
settup_zram.sh
mkswap.sh
swapon.sh
swapoff.sh
zram.service
zram.conf(modules-load.d & modprobe.d)
99-zram.rules

Issues:
Still can't hibernate

Works on Kali..should work on debian and ubuntu(linux with swap allocation on harddisk)

installation..

git clone '{}'
cd zram
sudo bash settup_zram.sh
