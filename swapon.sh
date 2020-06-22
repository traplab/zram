#!/usr/bin/bash

for a in `ls /dev/|grep zram`;
do sudo swapon /dev/$a;
done
