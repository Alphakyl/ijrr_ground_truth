/* Necessary for ROS */
#include <ros/ros.h>

/* Standard Message Types */
#include <geometry_msgs/PoseStamped.h>
#include <pose_graph_msgs/PoseGraph.h>
#include <nav_msgs/Odometry.h>



#include <iostream>
#include <fstream>

using namespace std;

ros::Publisher odom_pub;

int main(int argc, char** argv)
{
    /* Initialize ros and node*/
    ros::init(argc, argv, "pose_graph_2_odom");
    ros::NodeHandle n;

    /* Create publisher for Odom */
    odom_pub = n.advertise<nav_msgs::Odometry>("carto_odom", 1000);
    
    /* Create frame strings for later use */
    std::string parent_frame="world";
    std::string child_frame="imu_link_enu";

    /* Wait for message for 10 seconds */
    ros::Duration timeout(10.0);
    pose_graph_msgs::PoseGraphConstPtr carto_pose_graph_ptr = ros::topic::waitForMessage<pose_graph_msgs::PoseGraph>("pose_graph", timeout);
    if(carto_pose_graph_ptr==NULL){
        ROS_ERROR("No posegraph received");
    } else {
        ROS_INFO("Pose Graph Collected Properly");
        pose_graph_msgs::PoseGraph carto_pose_graph = *carto_pose_graph_ptr;
        /* Get message length, and loop through */
        int length = carto_pose_graph.poseGraph.size();
        for (int i=0;i<length;i++)
        {
            /* Create an empty odom message */
            nav_msgs::Odometry odom;
            /* Populate header from pose graph, with frames set by strings*/
            odom.child_frame_id = child_frame;
            odom.header=carto_pose_graph.poseGraph[i].header;
            odom.header.frame_id = parent_frame;
            /* Grab pose from pose graph */
            odom.pose.pose=carto_pose_graph.poseGraph[i].pose;
            /* Publish odom message */
            odom_pub.publish(odom);
        }
        cout << "Published full odometry" << endl;
    }

    return 0;
}