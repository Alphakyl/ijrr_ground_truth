#!/bin/bash
files=/media/kyle/45bfdd4b-6c7c-4d6a-a09d-21fbe576aa92/mc_data/2_24_2021/
scripts=/home/kyle/catkin_ws/src/ijrr_ground_truth/scripts/
for file in ${files}*
do
    BASE=${file##*/}
    DIR=${file%$BASE}
    mv ${file} ${DIR}${BASE%_merged.bag}
done