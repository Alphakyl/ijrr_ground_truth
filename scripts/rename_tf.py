import rosbag
from copy import deepcopy
import tf


bagInName = '/media/kyle/45bfdd4b-6c7c-4d6a-a09d-21fbe576aa92/mc_data/2_24_2021/aspen_run11.bag'
bagIn = rosbag.Bag(bagInName)
bagOutName = '/media/kyle/45bfdd4b-6c7c-4d6a-a09d-21fbe576aa92/mc_data/2_24_2021/aspen_run11_fixed.bag'
bagOut = rosbag.Bag(bagOutName,'w')
with bagOut as outbag:
    for topic, msg, t in bagIn.read_messages():
        if topic == '/tf':
            # print 'Found tf message'
            new_msg = deepcopy(msg)
            for i,m in enumerate(msg.transforms): # go through each frame->frame tf within the msg.transforms
                if m.header.frame_id == "world":
                    # print "Found world"
                    m.header.frame_id = "motion_capture"
                    new_msg.transforms[i] = m
                if m.child_frame_id == "kyleradar":
                    m.child_frame_id = "radar_rig"
                    new_msg.transforms[i] = m

            outbag.write(topic, new_msg, t)
        else:
            outbag.write(topic, msg, t)

bagIn.close()
bagOut.close()