#!/usr/bin/python2
import rospy
from geometry_msgs.msg import *
from nav_msgs.msg import *
from pose_graph_msgs.msg import *
from std_msgs.msg import *

class ODOM:
    def __init__(self):
        print "odom_initialized"
        self.world_frame_id = "world"
        self.base_frame_id = "imu_link_enu"
        

        print "publisher_created"
        self.pub=rospy.Publisher('pose_graph_odom', Odometry, queue_size=10)
        print "subscriber created"
        
        self.sub=rospy.Subscriber('/pose_graph', PoseGraph, self.pose_graph_cb)
    
    def pose_graph_cb(self, pgraph):
        print "Entered Callback"
        self.pose_graph_length = len(pgraph.poseGraph)
        print self.pose_graph_length
        for i in range(self.pose_graph_length):
            self.odom=Odometry()
            self.odom.child_frame_id=self.base_frame_id
            self.odom.header=pgraph.poseGraph[i].header
            self.odom.header.frame_id=self.world_frame_id
            self.odom.pose.pose=pgraph.poseGraph[i].pose
            self.pub.Publish(self.odom)
            rospy.sleep(rospy.Rate(20))

def main():
    rospy.init_node('posegraph2odom')
    create_odom=ODOM()
    while not rospy.is_shutdown():
        rospy.spin()

if __name__ == '__main__':
    main()        