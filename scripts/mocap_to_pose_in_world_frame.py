#!/usr/bin/python2
import rospy
from geometry_msgs.msg import *
from nav_msgs.msg import *
from pose_graph_msgs.msg import *
from std_msgs.msg import *
import tf2_ros
import math

def eob_cb(msg):
    rospy.signal_shutdown('End of Bag Reached')

if __name__ == '__main__':
    rospy.init_node('mocap_to_pose')
    tfBuffer=tf2_ros.Buffer()
    listener = tf2_ros.TransformListener(tfBuffer)
    tf_pub = rospy.Publisher('motion_capture_ground_truth', PoseStamped, queue_size=100)
    eob_sub = rospy.Subscriber('end_of_bag',String,eob_cb)

    rate = rospy.Rate(100.0)
    while not rospy.is_shutdown():
        try:
            trans = tfBuffer.lookup_transform('world', 'radar_rig',rospy.Time())
        except (tf2_ros.LookupException, tf2_ros.ConnectivityException, tf2_ros.ExtrapolationException):
            rate.sleep()
            continue
        msg = PoseStamped()
        msg.header.stamp = trans.header.stamp
        msg.header.frame_id = 'world'
        msg.pose.position.x = trans.transform.translation.x
        msg.pose.position.y = trans.transform.translation.y
        msg.pose.position.z = trans.transform.translation.z
        msg.pose.orientation.x = trans.transform.rotation.x
        msg.pose.orientation.y = trans.transform.rotation.y
        msg.pose.orientation.z = trans.transform.rotation.z
        msg.pose.orientation.w = trans.transform.rotation.w
        tf_pub.publish(msg)
        rate.sleep()

