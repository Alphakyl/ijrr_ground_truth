#!/bin/bash
files=/media/kyle/45bfdd4b-6c7c-4d6a-a09d-21fbe576aa92/ColoRadar_dataset/2_28_2021/
for file in ${files}*
do
    echo "Launching:"
    echo ${file}
    BASE=${file##*/}
    DIR=${file%$BASE}
    roslaunch ijrr_ground_truth home_test_3d.launch input_bag_filename:=${file} output_bag_filename:=${DIR}odom/${BASE%.bag}_odom.bag
done