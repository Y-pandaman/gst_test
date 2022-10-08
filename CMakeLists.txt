cmake_minimum_required(VERSION 3.5)
project(gst-test)

find_package(OpenCV REQUIRED)
include_directories(${OPENCV_INCLUDE_DIR})

add_executable(gst_receive src/gst_receive.cpp)
target_link_libraries(gst_receive ${OpenCV_LIBRARIES})

add_executable(gst_send src/gst_send.cpp)
target_link_libraries(gst_send ${OpenCV_LIBRARIES})
