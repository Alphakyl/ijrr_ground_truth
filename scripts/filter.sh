#!/bin/bash
files=/home/kyle/data/radar/icra/icra2021_test_data/ICRA2021_test_data/*
scripts=/home/kyle/catkin_ws/radar_viz/scripts/
for file in $files
do
    echo "Existing file:"
    echo ${file}
    echo "New file:"
    echo ${file%.bag}_no_tf.bag
    echo "Filter:"
    rosbag filter ${file} ${file%.bag}_no_tfs.bag "topic == '/imu_in/data' or topic == '/imu_out/data' or topic == '/os1_cloud_node/imu' or topic=='/os1_cloud_node/points'"
    echo "Filtering complete."
done
echo "Move files to new folder"
mkdir ./no_tfs
mv *_notfs.bag ./no_tfs/
cd ./no_tfs
no_tf_files = ./
for file in $no_tf_files
do
    echo "Apply flag to:"
    echo ${file}
    python ${scripts}/flag_eob.py ${file}
    echo "Flagging complete"
done
echo "Done"
