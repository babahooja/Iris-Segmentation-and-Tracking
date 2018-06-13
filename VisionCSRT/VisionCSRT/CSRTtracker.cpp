//
//  CSRTtracker.cpp
//  VisionCSRT
//
//  Created by Himanshu Ahuja on 10/06/18.
//  Copyright © 2018 Saturday Apps. All rights reserved.
//

#include "CSRTtracker.hpp"

supportCSRT::supportCSRT(float x, float y, float w, float h){
	tracker = TrackerCSRT::create();
	roi = Rect2d(x, y, w, h);
}

void supportCSRT::trackerUpdate(){
	
}
