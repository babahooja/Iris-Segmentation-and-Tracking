//
//  CSRT.h
//  VisionV2
//
//  Created by Himanshu Ahuja on 14/06/18.
//  Copyright © 2018 Saturday Apps. All rights reserved.
//

#include <CoreGraphics/CoreGraphics.h>
#include <CoreVideo/CoreVideo.h>
#include <CoreMedia/CoreMedia.h>
#include <AVFoundation/AVFoundation.h>
#include <opencv2/core/utility.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>

using namespace cv;

@interface CSRT: NSObject

@property (nonatomic) Ptr<TrackerCSRT> tracker;
@property (assign) Mat frame;
@property (assign) Rect2d roi;
- (id)initTrackerObject;
//- (id)initTrackerObject:(struct CGRect)bbox :(CMSampleBufferRef) frame;
- (struct CGRect)trackerUpdate:(struct CGRect)bbox :(CVPixelBufferRef) frame;
- (void)trackerInit:(struct CGRect)bbox :(CVPixelBufferRef) frame;
- (Mat)CVPixelBufferToMat:(CVPixelBufferRef) frame;

@end

