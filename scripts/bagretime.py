#!/usr/bin/env python
import sys
import roslib;
import rospy
import rosbag
from rospy import rostime
import argparse
import os

def parse_args():
    parser = argparse.ArgumentParser(
        prog = 'bagretime.py',
        description='Retimes a bagfile with header timestamps')
    parser.add_argument('-o', type=str, help='name of the output file',
        default = None, metavar = "output_file")
    parser.add_argument('bagfile', type=str, help='path to a bagfile, which will be the main bagfile')
    args = parser.parse_args()
    return args

def retime_bag(bagfile, outfile=None):
    if outfile == None:
        pattern = bagfile +"_retimed_%i.bag"
        outfile = bagfile
        index = 0
        while(os.path.exists(outfile)):
            outfile=pattern%index
            index += 1
    print "retime bag %s"%(bagfile)
    print "write to %s"%(outfile)

    with rosbag.Bag(outfile, 'w') as outbag:
        for topic, msg, t in rosbag.Bag(bagfile).read_messages():
            # This also replaces tf timestamps under the assumption 
            # that all transforms in the message share the same timestamp
            if topic == "/tf" and msg.transforms:
                outbag.write(topic, msg, msg.transforms[0].header.stamp)
            else:
                outbag.write(topic, msg, msg.header.stamp if msg._has_header else t)

if __name__ == "__main__":
    args = parse_args()
    print args
    retime_bag(args.bagfile,
        outfile = args.o)