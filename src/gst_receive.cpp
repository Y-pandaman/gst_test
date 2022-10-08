#include <iostream>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/opencv.hpp>
#include <stdio.h>

int main(int argc, char const *argv[]) {
  cv::Mat frame;
  std::string gst_str =
      "udpsrc port=5000 "
      "caps=application/x-rtp,media=(string)video,clock-rate=(int)90000,encoding-name=(string)H264,payload=(int)96 "
      "! rtpjitterbuffer ! rtph264depay ! h264parse ! queue ! avdec_h264 ! videoconvert ! video/x-raw ! appsink sync=false";
  cv::VideoCapture cap(gst_str);

  if(!cap.isOpened()){
    std::cout << "gst open failed" << std::endl;
    return 1;
  }

  while(1){
      cap >> frame;
      cv::imshow("gst-receive", frame);
      cv::waitKey(1);
  }
  cv::destroyWindow("gst-receive");
  cap.release();
  
  return 0;
}
