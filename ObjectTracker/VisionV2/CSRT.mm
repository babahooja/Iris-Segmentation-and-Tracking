//
//  CSRT.m
//  VisionV2
//
//  Created by Himanshu Ahuja on 14/06/18.
//  Copyright © 2018 Saturday Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "CSRT.h"

using namespace cv;

@implementation CSRT

//-(id)initTrackerObject:(struct CGRect)bbox :(CMSampleBufferRef)pixelFrame{
-(id)initTrackerObject{
	if (self = [super init]){
//		_frame = [self CMSampleBufferToMat:pixelFrame];
//		_roi = Rect2d(bbox.origin.x, bbox.origin.y, bbox.size.width, bbox.size.height);
		_tracker = TrackerCSRT::create();
	}
	return self;
}

-(void)trackerInit:(struct CGRect) bbox :(CMSampleBufferRef) pixelFrame{
	
	_roi = Rect2d(bbox.origin.x, bbox.origin.y, bbox.size.width, bbox.size.height);
	
	_frame = [self CMSampleBufferToMat:pixelFrame];
	_tracker->init(_frame, _roi);
}
-(struct CGRect)trackerUpdate:(struct CGRect) box :(CMSampleBufferRef) pixelFrame{
	_frame = [self CMSampleBufferToMat:pixelFrame];
	_tracker->update(_frame, _roi);
	struct CGRect temp;
	temp.size.height = _roi.height;
	temp.size.width = _roi.width;
	temp.origin.x = _roi.x;
	temp.origin.y = _roi.y;
	return temp;
}

-(Mat)CMSampleBufferToMat:(CMSampleBufferRef)pixelFrame{
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(pixelFrame);
	CVPixelBufferLockBaseAddress(imageBuffer,0);
	
	/*Get information about the image*/
	uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
	size_t width = CVPixelBufferGetWidth(imageBuffer);
	size_t height = CVPixelBufferGetHeight(imageBuffer);
	Mat frame(height, width, CV_8UC4, (void*)baseAddress);
	return frame;
}

@end

