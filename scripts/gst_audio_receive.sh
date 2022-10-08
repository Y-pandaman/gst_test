#!/bin/bash
PORT=${PORT:-5001}

gst-launch-1.0 udpsrc port=${PORT} caps="application/x-rtp" ! rtppcmadepay ! alawdec ! alsasink

