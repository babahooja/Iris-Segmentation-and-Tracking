//
//  OpenCVWrapper.h
//  V100
//
//  Created by Himanshu Ahuja on 01/07/18.
//  Copyright © 2018 Himanshu Ahuja. All rights reserved.
//

//#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//using namespace cv;

@interface OpenCVWrapper : NSObject
//    cv::cvMat &hello;
-(void)processImage:(NSArray*)image :(CGRect)roi :(int)numSamples;
@end
