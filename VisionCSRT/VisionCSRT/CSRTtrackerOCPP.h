//
//  CSRTtrackerOCPP.h
//  VisionCSRT
//
//  Created by Himanshu Ahuja on 13/06/18.
//  Copyright © 2018 neuro.uno. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreVideo/CoreVideo.h>
#include <opencv2/core/utility.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>

using namespace cv;

//#ifndef CSRTtrackerOCPP_h
//#define CSRTtrackerOCPP_h

@interface CSRTtrackerOCPP: NSObject

@property (nonatomic) Ptr<TrackerCSRT> tracker;
@property (assign) Mat frame;
@property (assign) Rect2d roi;
- (struct CGRect)trackerUpdateFromCPP:(struct CGRect)bbox :(CVPixelBufferRef) frame;
- (void)trackerInitFromCPP:(struct CGRect)bbox :(CVPixelBufferRef) frame;

@end

//#endif /* CSRTtrackerOCPP_h */
