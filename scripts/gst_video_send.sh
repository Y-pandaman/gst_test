#!/bin/bash

DEVICE=${DEVICE:-/dev/video0}
IP=${IP:-192.168.8.2}
PORT=${PORT:-5000}
WIDTH=${WIDTH:-1280}
HEIGHT=${HEIGHT:-720}
FPS=${FPS:-30}
ENCODING=${ENCODING:-h264}
IS_COMPRESSED=${IS_COMPRESSED:-true}
IS_USE_NVENC=${IS_USE_NVENC:-false}
IS_MULTIUDP=${IS_MULTIUDP:-false}

if [ "${IS_MULTIUDP}" = "false" ] ; then
    if [ "${ENCODING}" = "h264" ] ; then
        if [ "${IS_COMPRESSED}" = "true" ] ; then
            if [ "${IS_USE_NVENC}" = "true" ] ; then
                gst-launch-1.0 -v v4l2src device=${DEVICE} ! image/jpeg,width=${WIDTH},height=${HEIGHT},framerate=${FPS}/1 ! jpegparse ! jpegdec ! 'video/x-raw' ! nvvidconv ! 'video/x-raw(memory:NVMM),format=I420,width=1280,height=720' ! omxh264enc bitrate=500 preset-level=0 ! h264parse ! 'video/x-h264,stream-format=byte-stream' ! rtph264pay name=pay0 pt=96 ! udpsink host=${IP} port=${PORT} async=false sync=false
            else
                gst-launch-1.0 -v v4l2src device=${DEVICE} ! image/jpeg,width=${WIDTH},height=${HEIGHT},framerate=${FPS}/1 ! jpegdec ! videoscale ! videoconvert ! queue ! x264enc tune=zerolatency bitrate=500 speed-preset=superfast ! rtph264pay ! udpsink host=${IP} port=${PORT}
            fi
        else
            gst-launch-1.0 -v v4l2src device=${DEVICE} ! video/x-raw,width=${WIDTH},height=${HEIGHT},framerate=${FPS}/1 ! videoscale ! videoconvert ! queue ! x264enc tune=zerolatency bitrate=500 speed-preset=superfast ! rtph264pay ! udpsink host=${IP} port=${PORT}
        fi
    elif [ "${ENCODING}" = "h265" ] ; then
        gst-launch-1.0 -v v4l2src device=${DEVICE} ! image/jpeg,width=${WIDTH},height=${HEIGHT},framerate=${FPS}/1 ! jpegdec ! videoscale ! videoconvert ! queue ! x265enc tune=zerolatency bitrate=500 speed-preset=superfast ! rtph265pay ! udpsink host=${IP} port=${PORT}
    fi
else
    if [ "${ENCODING}" = "h264" ] ; then
        if [ "${IS_COMPRESSED}" = "true" ] ; then
            if [ "${IS_USE_NVENC}" = "true" ] ; then
                gst-launch-1.0 -vvv v4l2src device=${DEVICE} ! image/jpeg, width=${WIDTH}, height=${HEIGHT}, framerate=${FPS}/1 ! jpegparse ! jpegdec ! 'video/x-raw' ! nvvidconv ! 'video/x-raw(memory:NVMM),format=I420,width=1280,height=720' ! omxh264enc bitrate=1000 preset-level=0 ! h264parse ! 'video/x-h264,stream-format=byte-stream' ! rtph264pay name=pay0 pt=96 ! multiudpsink clients="${IP}:5000,${IP}:5001,${IP}:5002,${IP}:5003,${IP}:5004,${IP}:5005,${IP}:5006,${IP}:5007" async=false sync=false
            fi
        fi
    fi
fi
