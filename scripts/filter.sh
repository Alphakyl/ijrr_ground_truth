#!/bin/bash
files=/home/kyle/data/radar/ijrr/cascade_radar_rig/12_21_2020/*
scripts=/home/kyle/catkin_ws/radar_viz/scripts/
for file in $files
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
mkdir $files/no_tfs
mv *_notfs.bag $files/no_tfs/
cd $files/no_tfs
# no_tf_files = ./
# for file in $no_tf_files
# do
#     echo "Apply flag to:"
#     echo ${file}
#     python ${scripts}/flag_eob.py ${file}
#     echo "Flagging complete"
# done
# echo "Done"
