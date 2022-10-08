#!/bin/bash

DEVICE=${DEVICE:-hw:0,0}
IP=${IP:-192.168.89.94}
PORT=${PORT:-5001}

gst-launch-1.0 alsasrc device=${DEVICE} ! audioconvert ! audioresample  ! alawenc ! rtppcmapay ! udpsink host=${IP} port=${PORT}


