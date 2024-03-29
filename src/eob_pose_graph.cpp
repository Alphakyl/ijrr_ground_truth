#include <ros/ros.h>
#include <cartographer_ros_msgs/TrajectoryQuery.h>
#include <cartographer_ros_msgs/StatusResponse.h>
#include <geometry_msgs/Point.h>
#include <geometry_msgs/PoseStamped.h>
#include <nav_msgs/Odometry.h>
#include <pose_graph_msgs/PoseGraph.h>
#include <std_msgs/String.h>
#include <iostream>
#include <fstream>

using namespace std;

ros::Publisher pose_graph_pub;
ros::Publisher odom_pub;
ros::Subscriber eob_sub;
ros::ServiceClient pgraph_client;

void trajectory_callback(const vector<geometry_msgs::PoseStamped>&);
void eob_callback(const std_msgs::String::ConstPtr& msg);


int main(int argc, char **argv)
{
    ros::init(argc, argv, "pose_graph_client");
    ros::NodeHandle n;
    pose_graph_pub = n.advertise<pose_graph_msgs::PoseGraph>("pose_graph", 100);
    odom_pub = n.advertise<nav_msgs::Odometry>("lidar_ground_truth",4000);
    pgraph_client = n.serviceClient<cartographer_ros_msgs::TrajectoryQuery>("trajectory_query");
    eob_sub = n.subscribe("/end_of_bag",1,eob_callback);
    ros::Rate r(10);
    while(ros::ok()){
        r.sleep();
        ros::spinOnce();
    }
    return 0;
}

void eob_callback(const std_msgs::String::ConstPtr& msg)
{
    ros::Duration(10).sleep();
    cartographer_ros_msgs::TrajectoryQuery srv;
    srv.request.trajectory_id = 0;
    if(pgraph_client.call(srv))
    {
        cout << "Trajectory Status: " << srv.response.status.message << endl;
        cout << "Trajectory Size: " << srv.response.trajectory.size() <<endl;
    }
    else
    {
        ROS_ERROR("Failed to call service 'trajectory_query'");
    }
    trajectory_callback(srv.response.trajectory);
}

void trajectory_callback(const vector<geometry_msgs::PoseStamped>& msg)
{
    /* Create frame strings for later use */
    std::string parent_frame="world";
    std::string child_frame="imu_link_enu";

    pose_graph_msgs::PoseGraph pose_graph;
    pose_graph.poseGraph = msg;
    pose_graph_pub.publish(pose_graph);
    ros::Rate loop_rate(100);
    loop_rate.sleep();
    pose_graph_pub.publish(pose_graph);

    int length = msg.size();
    cout << msg[0].header.stamp << " " << msg[length-1].header.stamp << endl;

    for (int i=0;i<length;i++)
    {
        /* Create an empty odom message */
        nav_msgs::Odometry odom;
        /* Populate header from pose graph, with frames set by strings*/
        odom.child_frame_id = child_frame;
        odom.header=msg[i].header;
        odom.header.frame_id = parent_frame;
        /* Grab pose from pose graph */
        odom.pose.pose=msg[i].pose;
        /* Publish odom message */
        odom_pub.publish(odom);
        loop_rate.sleep();
        //cout << i << endl;
    }
    cout << "Published full odometry" << endl;
    ros::shutdown();
}