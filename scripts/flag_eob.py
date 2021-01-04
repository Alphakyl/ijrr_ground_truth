#!/usr/bin/env python2
import sys
import roslib;
import rosbag
import rospy
from rospy import rostime
from std_msgs.msg import *
import argparse
import os

def parse_args():
    parser = argparse.ArgumentParser(prog = 'flag_eob.py', description='Flag end of a bag.')
    parser.add_argument('bagfile', type=str, help='path to the bagfile to be flagged')
    args=parser.parse_args()
    return args

def flag_bag(bagfile):
    print "flag bag %s"%(bagfile)
    with rosbag.Bag(bag_name, 'a') as bag:
        metadata_msg = String()
        metadata_msg.data='True'
        bag.write('/end_of_bag', metadata_msg, rospy.Time(bag.get_end_time()))

if __name__ == "__main__":
#    rospy.init_node('eob')
    args = parse_args()
    print args
    flag_bag(args.bagfile)
