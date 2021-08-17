#!/bin/bash
files=/home/kyle/data/radar/ijrr/cascade_radar_rig/12_21_2020/
scripts=/home/kyle/catkin_ws/src/ijrr_ground_truth/scripts/

for file in ${files}*
do
    if [[ ${file} == *".bag" ]]
    then
        BASE=${file##*/}
        DIR=${file%$BASE}
        python ${scripts}bagmerge.py ${file} ${DIR}odom/${BASE%.bag}_odom_retimed.bag
    fi
done