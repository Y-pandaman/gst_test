#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>

int main(int argc, char const *argv[])
{
    cv::VideoCapture cap(0);
    if(!cap.isOpened()){
        std::cout << "camera open failed" << std::endl;
        return 1;
    }

    std::string ip = "192.168.89.94";
    std::string port = "5000";
    std::string width = "1280";
    std::string height = "720";
    std::string gst_str = "appsrc ! queue !  videoconvert ! video/x-raw,format=I420,width=" + width + ",height=" + height + " ! x264enc tune=zerolatency bitrate=1024 speed-preset=superfast ! h264parse ! rtph264pay ! udpsink host=" + ip + " port=" + port + " sync=false";
    cv::VideoWriter writer(gst_str.c_str(), cv::CAP_GSTREAMER, 0, 30, cv::Size(1280, 720), true);

    if (!writer.isOpened()) {
        std::cout <<"VideoWriter not opened"<< std::endl;
        exit(-1);
    }

    cv::Mat frame;

    while(1){
        cap.read(frame);
        cv::resize(frame, frame,cv::Size(1280,720));
        writer.write(frame);
    }
    writer.release();
    return 0;
}
