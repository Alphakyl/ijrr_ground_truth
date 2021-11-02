#!/bin/bash
files=/home/kyle/data/radar/wadar/cu_south/
scripts=/home/kyle/catkin_ws/src/ijrr_ground_truth/scripts/

for file in ${files}odom/*
do
    echo "Retime file:"
    echo ${file}
    python ${scripts}bagretime.py ${file}
done

for file in ${files}*
do
    BASE=${file##*/}
    DIR=${file%$BASE}
    python ${scripts}bagmerge.py ${file} ${DIR}odom/${BASE%.bag}_odom_retimed.bag
done