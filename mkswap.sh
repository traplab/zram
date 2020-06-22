#!/usr/bin/bash

for a in `ls /dev/|grep zram`;
do sudo mkswap /dev/$a;
done
