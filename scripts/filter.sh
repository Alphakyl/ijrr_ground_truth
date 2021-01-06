#!/bin/bash
files=/home/kyle/data/radar/ijrr/cascade_radar_rig/12_21_2020/
scripts=/home/kyle/catkin_ws/src/ijrr_ground_truth/scripts/
for file in ${files}*
do
    echo "Existing file:"
    echo ${file}
    echo "New file:"
    echo ${file%.bag}_no_tf.bag
    echo "Filter:"
    rosbag filter ${file} ${file%.bag}_no_tfs.bag "topic == '/gx5/imu/data' or topic == '/os1_cloud_node/imu' or topic=='/os1_cloud_node/points'"
    echo "Filtering complete."
done
echo "Move files to new folder"
mkdir ${files}/no_tfs
for file in ${files}*
do
    STR_CMP="no_tfs.bag"
    if [[ ${file} == *"$STR_CMP" ]]
    then
        mv ${file} ${files}/no_tfs/
    fi  
done
echo "Add processing flag to end of bag"
for file in ${files}no_tfs/*
do
    echo "Apply flag to:"
    echo ${file}
    python ${scripts}flag_eob.py ${file}
    echo "Flagging complete"
done
mkdir ${files}odom
echo "Done"
