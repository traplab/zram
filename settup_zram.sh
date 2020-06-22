#!/usr/bin/env bash

if [[ $UID -ne 0 ]];
then 
echo "must run script with priviledge"
exit
else

#sudo su
cat << heredoc
System will restart on completion
Press Ctrl+C within 10 sec
heredoc

sleep 14
#De-activating swap

cat << heredoc
Deactivating swap
heredoc

#clear

swap_device="$( sudo cat /proc/swaps|grep dev| awk '{print $1}')"
swapoff "$swap_device"
#UUID

swap_uuid="$(blkid $swap_device|awk '{print $2}'|sed 's/\"//'|sed 's/\"// ')"
#echo -e "$swap_uuid"
#deactivating auto-enable swap on fstab

sudo cp /etc/fstab{,.bkp} && echo "fstab backup complete"

sed -i "s|$swap_uuid|#$swap_uuid|g" /etc/fstab && echo "fstab adjustment done"

cat << heredoc
creating zram modules
heredoc

#clear
#number of cores

CORES="$( nproc )"
#RAM
#RAM="$(cat /proc/meminfo |grep MemTotal| awk '{print $2}')"
RAM="$(perl -ne '/^MemTotal:\s+(\d+)/ && print $1' < /proc/meminfo)"
#fraction
FRACTION=75

#advisable zram 

modprobe zram num_devices=$CORES

SIZE=$(( $RAM*$FRACTION/100/$CORES ))

#create necessary files for start-up purposes

echo "zram" > /etc/modules-load.d/zram.conf
echo "options zram num_devices=$CORES" > /etc/modprobe.d/zram.conf
SUFFIX="KiB"
for n in $( seq $CORES)
do
i=$((n - 1))
echo -e " KERNEL==\"zram$i\", ATTR{disksize}=\"$SIZE$SUFFIX\",TAG+=\"systemd\" " > /etc/udev/rules.d/99-zram.rules
done

#service scripts
for file in mkswap.sh swapon.sh swapoff.sh
do
cp $file /usr/local/bin/ && chmod +x $file
done

#service
cp ./zram.service /etc/systemd/system/


systemctl enable zram.service
reboot -f
fi


