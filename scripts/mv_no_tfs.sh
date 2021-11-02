#!/bin/bash
files=/home/kyle/data/radar/wadar/
echo "Move files to new folder"
mkdir ${files}/no_tfs
for file in ${files}*
do
    STR="${file}"
    STR_CMP="no_tf.bag"
    if [[ ${file} == *"$STR_CMP" ]]
    then
        mv ${file} ${files}/no_tfs/
    fi  
done
