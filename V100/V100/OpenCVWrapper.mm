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
#import <opencv2/core/utility.hpp>
#import <opencv2/tracking.hpp>
#import <opencv2/videoio.hpp>
#import <opencv2/highgui.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVWrapper.h"

#import <AVFoundation/AVFoundation.h>

using namespace std;
using namespace cv;

@interface OpenCVWrapper()
//-(void)processImage:(NSArray*)image;

@end

@implementation OpenCVWrapper
-(void)processImage:(NSArray*)image :(CGRect)roi :(int)numSamples
{
    printf("We are in processing image function.\n");
    Mat imageMat;
    
    Ptr<TrackerCSRT> tracker = TrackerCSRT::create();
    
    cv::Rect2d roi_rect = Rect2d(
                          int(roi.origin.x - roi.size.width/2),
                          int(roi.origin.y - roi.size.height/2),
                          int(roi.size.width),
                          int(roi.size.height));
    
//    NSLog(@"%@", [NSString stringWithFormat:@"(%.2f,%.2f,%.2f,%.2f)", roi_rect.x, roi_rect.y, roi_rect.width, roi_rect.height]);
//
    UIImageToMat(image[0], imageMat);
    cvtColor(imageMat, imageMat, CV_BGRA2BGR);
    
    printf("Number of channels: %d", imageMat.channels());
    printf("Does this work?");
    tracker->init(imageMat, roi_rect);
    printf("\nThe initialization works\n\n");
//    Mat imageMat[numSamples];
    for(int i = 1; i < numSamples; i++){
        UIImageToMat(image[i], imageMat);
        cvtColor(imageMat, imageMat, CV_BGRA2BGR);
//        printf(NSString stringWithFormat:@"(%d, %d)", imageMat.rows, imageMat.cols);
        printf("(%.2f,%.2f,%.2f,%.2f)", roi_rect.x, roi_rect.y, roi_rect.width, roi_rect.height);
        tracker->update(imageMat, roi_rect);
    }
    
//
//    tracker->init(frame, roi);
    // Do some OpenCV stuff with the image
//
//    UIImageToMat(image[0], imageMat);
    
//    UIImage* img = MatToUIImage(imageMat);
//    cvtColor(image, image_copy, CV_BGRA2BGR);
//
//    // invert image
//    bitwise_not(image_copy, image_copy);
//    cvtColor(image_copy, image, CV_BGR2BGRA);
}

@end
