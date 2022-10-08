#!/bin/bash

time=$(date "+%Y-%m-%d-%H:%M:%S")

PORT=${PORT:-5000}
ENCODING=${ENCODING:-h264}

if [ "${ENCODING}" = "h264" ] ; then
    gst-launch-1.0 -v udpsrc  address="192.168.89.130" port=${PORT} caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtpjitterbuffer ! rtph264depay ! h264parse ! queue ! avdec_h264 ! videoconvert ! video/x-raw ! fpsdisplaysink sync=false
elif [ "${ENCODING}" = "h265" ] ; then
    gst-launch-1.0 -v udpsrc port=${PORT} caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H265, payload=(int)96" ! rtpjitterbuffer ! rtph265depay ! h265parse ! queue ! avdec_h265 ! videoconvert ! video/x-raw ! autovideosink
fi

# receive and save video
#gst-launch-1.0 -v udpsrc port=5000 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtpjitterbuffer ! rtph264depay ! h264parse ! tee name=t t. ! queue leaky=1 ! avdec_h264 ! videoconvert ! video/x-raw ! autovideosink sync=false t. ! queue ! avimux ! filesink location=$time.avi
