//
//  CSRTtracker.hpp
//  VisionCSRT
//
//  Created by Himanshu Ahuja on 6/8/18.
//  Copyright © 2018 neuro.uno. All rights reserved.
//

#include <opencv2/core/utility.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>
#include <cstring>
#include <iostream>

using namespace cv;
using namespace std;

class supportCSRT{
public:
	Ptr<TrackerCSRT> tracker;
	Rect2d roi;
	Mat frame;
	string video;
	supportCSRT(float, float, float, float);
	void trackerUpdate();
};
