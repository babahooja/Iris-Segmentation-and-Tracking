//
//  CameraController.swift
//  Iris Tracker
//
//  Created by Himanshu Ahuja on 16/05/18.
//  Copyright © 2018 Himanshu Ahuja. All rights reserved.
//

import AVFoundation



class CameraController{
	// prepares the capture session for use and calls
	// completion handler when it's done
	var captureSession : AVCaptureSession?
	var frontCamera : AVCaptureDevice?
	var rear
	func prepare(completionHandler : @escaping (Error?) -> Void){
		func createCaptureSession() {
			self.captureSession = AVCaptureSession()
		}
		func configureCaptureDevices() throws {}
		func configureDeviceInputs() throws {}
		func configurePhotoOutput() throws {}
		
		DispatchQueue(label: "prepare").async{
			/*We’ve also set up an asynchronously executing
			block that calls the four functions, catches any
			errors if necessary, and then calls the completion handler.*/
			do {
				createCaptureSession()
				try configureCaptureDevices()
				try configureDeviceInputs()
				try configurePhotoOutput()
			}
			catch {
				DispatchQueue.main.async {
					completionHandler(error)
				}
				return
			}
			DispatchQueue.main.async {
				completionHandler(nil)
			}
		}
		
	}
}
