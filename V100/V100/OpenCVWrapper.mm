//
//  OpenCVWrapper.m
//  V100
//
//  Created by Himanshu Ahuja on 01/07/18.
//  Copyright © 2018 Himanshu Ahuja. All rights reserved.
//
// Add the opencv headers above the
#import <opencv2/opencv.hpp>
#import <opencv2/opencv.hpp>
#include <opencv2/core/utility.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>
#import "OpenCVWrapper.h"

using namespace std;
using namespace cv;

@implementation OpenCVWrapper
- (void) isThisWorking {
//    cout << "Hey" << endl;
//    Rect2d roi;
//    Mat frame;
//    // create a tracker object
//    Ptr<TrackerCSRT> tracker = TrackerCSRT::create();
//    // set input video
//    //    string video = argv[1];
//    //    VideoCapture cap(video);
//    VideoCapture cap(0); // for webcam
//
//    // get bounding box
//    cap >> frame;
//    roi=selectROI("tracker",frame);
//    //quit if ROI was not selected
//    if(roi.width==0 || roi.height==0)
//
//        return 0;
//    // initialize the tracker
//    tracker->init(frame,roi);
//    // perform the tracking process
//    printf("Start the tracking process, press ESC to quit.\n");
//    for ( ;; ){
//        // get frame from the video
//        cap >> frame;
//        // stop the program if no more images
//        if(frame.rows==0 || frame.cols==0)
//            break;
//        // update the tracking result
//        tracker->update(frame,roi);
//        // draw the tracked object
//        rectangle( frame, roi, Scalar( 255, 0, 0 ), 2, 1 );
//        // show image with the tracked object
//        imshow("tracker",frame);
//        //quit on ESC button
//        if(waitKey(1)==27)break;
//    }
//    return 0;
    cout<<"Hello sexy!";
}
@end
