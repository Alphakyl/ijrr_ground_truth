#!/bin/bash
files=/home/kyle/data/radar/ijrr/cascade_radar_rig/12_21_2020/
echo "Move files to new folder"
mkdir ${files}/no_tfs
for file in ${files}*
do
    STR="${file}"
    STR_CMP="no_tfs.bag"
    if [[ ${file} == *"$STR_CMP" ]]
    then
        mv ${file} ${files}/no_tfs/
    fi  
done
