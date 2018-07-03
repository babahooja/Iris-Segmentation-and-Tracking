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
-(void)processImage:(NSArray*)image
{
    // Do some OpenCV stuff with the image
    Mat imageMat;
    UIImageToMat(image[0], imageMat);
    
//    UIImage* img = MatToUIImage(imageMat);
//    cvtColor(image, image_copy, CV_BGRA2BGR);
//
//    // invert image
//    bitwise_not(image_copy, image_copy);
//    cvtColor(image_copy, image, CV_BGR2BGRA);
}
@end
