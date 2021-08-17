-- Copyright 2016 The Cartographer Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "map",
  tracking_frame = "imu_viz_link",
  published_frame = "imu_viz_link",
  odom_frame = "odom",
  provide_odom_frame = true,
  publish_frame_projected_to_2d = false,
  use_pose_extrapolator = false,
  use_odometry = false,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 0,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 1,
  lookup_transform_timeout_sec = 0.2,
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  rangefinder_sampling_ratio = 1.,
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 1.,
}

------------------------
-- Trajectory Builder --
------------------------
MAX_3D_RANGE = 60.  --Kyle 100 --default 60. 
TRAJECTORY_BUILDER_3D.min_range = 1.  --default 1.
TRAJECTORY_BUILDER_3D.num_accumulated_range_data = 1  --default 1.
voxel_filter_size = 0.15  --default 0.15


-- TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter.max_length = 2.0 --default 2.0
-- TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter.min_num_points=150 --default 150
-- TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter.max_range = 15.0 --default 15

-- TRAJECTORY_BUILDER_3D.low_resolution_adaptive_voxel_filter.max_length = 4.0  --default 4.0
-- TRAJECTORY_BUILDER_3D.min_num_points = 200 --default 200
-- TRAJECTORY_BUILDER_3D.max_range = MAX_3D_RANGE --default MAX_3D_RANGE

-- TRAJECTORY_BUILDER_3D.use_online_correlative_scan_matching = false --default false gene false
-- TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.linear_search_window = 0.15 --default 0.15  gene 0.11
-- TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.angular_search_window = math.rad(1.)  --default .1    gene 1.  kyle 1
-- TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.translation_delta_cost_weight = 1e-1  --default 1e-1   
-- TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.rotation_delta_cost_weight = 1e-1 --default 1e-1

-- TRAJECTORY_BUILDER_3D.ceres_scan_matcher.occupied_space_weight_0 = 1.  --default 1.    
-- TRAJECTORY_BUILDER_3D.ceres_scan_matcher.occupied_space_weight_1 = 6.  --default 6.
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.translation_weight = 5  --default 5.  gene 3.
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.rotation_weight = 4e2 --default 4e2   gene 30 kyle 1.5e2
-- TRAJECTORY_BUILDER_3D.ceres_scan_matcher.only_optimize_yaw = false --default false
-- TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.use_nonmonotonic_steps = false --default false
-- TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.max_num_iterations	= 12  --default 12
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.num_threads = 4 --default 1     gene 6

-- TRAJECTORY_BUILDER_3D.motion_filter.max_time_seconds = 0.5 --default 0.5
-- TRAJECTORY_BUILDER_3D.motion_filter.max_distance_meters= 0.1 --default 0.1
-- TRAJECTORY_BUILDER_3D.motion_filter.max_angle_radians = 0.04 --default 0.004

TRAJECTORY_BUILDER_3D.submaps.high_resolution = 0.10  --default 0.10 
-- TRAJECTORY_BUILDER_3D.submaps.high_resolution_max_range = 20.  --default 20. 
-- TRAJECTORY_BUILDER_3D.submaps.low_resolution = 0.45  --default 0.45
TRAJECTORY_BUILDER_3D.submaps.num_range_data = 160  --default 160
-- TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.hit_probability = .55  --default 0.55  gene 0.55
-- TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.miss_probability =.45  --default 0.49  gene 0.45
-- TRAJECTORY_BUILDER_3D.submaps.num_free_space_voxels = 2  --default 2

TRAJECTORY_BUILDER_3D.imu_gravity_time_constant = 9.8


-----------------
-- Map Builder --
-----------------
MAP_BUILDER.use_trajectory_builder_3d = true
MAP_BUILDER.num_background_threads = 7 

----------------
-- Pose Graph --
----------------
POSE_GRAPH.optimize_every_n_nodes = 45  --default 90      gene 45

POSE_GRAPH.constraint_builder.sampling_ratio = 0.3 --default 0.3     gene 0.03
-- POSE_GRAPH.constraint_builder.max_constraint_distance = 30 --default 15      gene 30
POSE_GRAPH.constraint_builder.min_score = 0.55  --default 0.55    gene 0.55         
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.6 --default 0.6     gene 0.66
POSE_GRAPH.constraint_builder.loop_closure_translation_weight = 1.1e4 --default 1.1e4
POSE_GRAPH.constraint_builder.loop_closure_rotation_weight = 1e5  --default 1e5
POSE_GRAPH.constraint_builder.log_matches = false --default true


-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.branch_and_bound_depth = 8  --default 8
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.full_resolution_depth = 3 --default 3
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.min_rotational_score = 0.77 --default 0.77
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.min_low_resolution_score = 0.55 --default 0.55       
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_xy_search_window = 5.  --default 5.  gene 5.
POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_z_search_window = 3 --default 1.  gene 3
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.angular_search_window = math.rad(22.5)  --default 15  gene 22.5


-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.occupied_space_weight_0 = 5. --default 5.
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.occupied_space_weight_1 = 30.  --default 30.
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.translation_weight = 10  --default 5     gene 10
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.rotation_weight = 100. --default 1
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.only_optimize_yaw = false  --default false gene false
POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.num_threads = 4  --default 1 gene 6
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.use_nonmonotonic_steps = false  --default false
-- POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.max_num_iterations = 10 --default 10

POSE_GRAPH.optimization_problem.huber_scale = 1e1 --default 1e1 gene 5e2
-- POSE_GRAPH.optimization_problem.acceleration_weight = 1e3  --default 1e3
-- POSE_GRAPH.optimization_problem.rotation_weight = 3e5  --default 3e5
-- POSE_GRAPH.optimization_problem.local_slam_pose_translation_weight = 1e5 --default 1e5
-- POSE_GRAPH.optimization_problem.local_slam_pose_rotation_weight = 1e5  --default 1e5
-- POSE_GRAPH.optimization_problem.odometry_translation_weight = 1e5    --default 1e5
-- POSE_GRAPH.optimization_problem.odometry_rotation_weight = 1e5 --default 1e5
-- POSE_GRAPH.optimization_problem.fixed_frame_pose_translation_weight = 1e1  --default 1e1
-- POSE_GRAPH.optimization_problem.fixed_frame_pose_rotation_weight = 1e2 --default 1e2
POSE_GRAPH.optimization_problem.log_solver_summary = true --default false   gene true
POSE_GRAPH.optimization_problem.use_online_imu_extrinsics_in_3d = false   --default true    gene false
POSE_GRAPH.optimization_problem.fix_z_in_3d = false   --default false   gene false
POSE_GRAPH.optimization_problem.ceres_solver_options.use_nonmonotonic_steps = false --default false
POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 7 --default 50      gene 5
POSE_GRAPH.optimization_problem.ceres_solver_options.num_threads = 7  --default 7       gene 6

return options
