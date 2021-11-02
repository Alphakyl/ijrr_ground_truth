#!/bin/bash
files=/home/kyle/data/radar/wadar/
scripts=/home/kyle/catkin_ws/src/ijrr_ground_truth/scripts/
for file in ${files}*
do
    BASE=${file##*/}
    DIR=${file%$BASE}
    mv ${file} ${DIR}${BASE%_merged.bag}
done