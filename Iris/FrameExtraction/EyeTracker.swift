//
//  EyeTracker.swift
//  FrameExtraction
//
//  Created by Himanshu Ahuja on 21/05/18.
//  Copyright © 2018 bRo. All rights reserved.
//

import Vision
import UIKit

class EyeTracker{
		weak var highlightView: UIView? {
			didSet {
				self.highlightView?.layer.borderColor = UIColor.red.cgColor
				self.highlightView?.layer.borderWidth = 4
				self.highlightView?.backgroundColor = .clear
			}
		}
	
	
//	 Variables and instance for Vision module (Tracking)
	////////////////////////////////////////////////////////////
		let visionSequenceHandler = VNSequenceRequestHandler()
	/*The vision sequence system works in a loop. You provide a
	"seed" observation, then feed that into the vision system.
	The vision system then outputs a new observation.*/
		var lastObservation: VNDetectedObjectObservation?
	///////////////////////////////////////////////////////////
}
