//
//  CSRTtrackerOCPP.mm
//  VisionCSRT
//
//  Created by Himanshu Ahuja on 10/06/18.
//  Copyright © 2018 neuro.uno . All rights reserved.
//

#import "CSRTtrackerOCPP.h"
#include "CSRTtracker.hpp"
#include <CoreGraphics/CGGeometry.h>
#include <CoreVideo/CoreVideo.h>

@implementation CSRTtrackerOCPP

-(void)trackerInitFromCPP:(struct CGRect) bbox :(CVPixelBufferRef) frame{
	
	float x = bbox.origin.x;
	float y = bbox.origin.y;
	float w = bbox.size.width;
	float h = bbox.size.height;
	
	supportCSRT trackerHandler(x, y, w, h);
	trackerHandler.trackerUpdate();
}
-(struct CGRect)trackerUpdateFromCPP:(struct CGRect) box :(CVPixelBufferRef) frame{
	trackerHandler.
	return box;
}

@end
