#!/bin/bash
files=/media/kyle/45bfdd4b-6c7c-4d6a-a09d-21fbe576aa92/2_24_2021/
scripts=/home/kyle/catkin_ws/src/ijrr_ground_truth/scripts/
echo "test"
for file in ${files}*
do
    echo "Existing file:"
    echo ${file}
    echo "New file:"
    echo ${file%.bag}_no_vicon.bag
    echo "Filter:"
    rosbag filter ${file} ${file%.bag}_no_vicon.bag "topic=='/gx5/imu/data' or\
    topic=='/os1_cloud_node/imu' or \
    topic=='/os1_cloud_node/points' or \
    topic=='/cascade/data_cube' or \
    topic=='/cascade/heatmap' or \
    topic=='/dca_node/data_cube' or \
    topic=='/dca_node/heatmap' or \
    topic=='/end_of_bag' or \
    topic=='/gx5/imu/data' or \
    topic=='/lidar_ground_truth' or \
    topic=='/mmWaveDataHdl/RScan' or \
    topic=='/tf' or \
    topic=='/tf_static'"
    echo "Filtering complete."
done