#!/bin/bash
files=/home/kyle/data/radar/ijrr/cascade_radar_rig/12_21_2020/
scripts=/home/kyle/catkin_ws/src/ijrr_ground_truth/scripts/

for file in ${files}no_tfs/*
do
    echo "Apply flag to:"
    echo ${file}
    python ${scripts}flag_eob.py ${file}
    echo "Flagging complete"
done
echo "Done"
