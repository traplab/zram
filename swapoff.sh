#!/usr/bin/bash

for a in `ls /dev/|grep zram`;
do sudo swapff /dev/$a;
done
