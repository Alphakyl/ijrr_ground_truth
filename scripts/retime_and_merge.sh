#!/bin/bash
files=/media/kyle/45bfdd4b-6c7c-4d6a-a09d-21fbe576aa92/mc_data/2_24_2021/
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