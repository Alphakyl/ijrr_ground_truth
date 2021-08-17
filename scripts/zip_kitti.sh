#!/bin/bash
files=/media/kyle/45bfdd4b-6c7c-4d6a-a09d-21fbe576aa92/ColoRadar_kitti/
scripts=/home/kyle/catkin_ws/src/ijrr_ground_truth/scripts/
for file in ${files}*
do
    echo "Zipping:"
    echo ${file}
    zip -r ${file}.zip ${file}
    echo "Done."
done