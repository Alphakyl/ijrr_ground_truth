#!/bin/bash
files=/home/kyle/data/radar/wadar/cu_south/
for file in ${files}*
do
    echo "Launching:"
    echo ${file}
    BASE=${file##*/}
    DIR=${file%$BASE}
    roslaunch ijrr_ground_truth home_test_3d.launch input_bag_filename:=${file} output_bag_filename:=${DIR}odom/${BASE%.bag}_odom.bag
done