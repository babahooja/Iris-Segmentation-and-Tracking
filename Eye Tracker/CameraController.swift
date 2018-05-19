////
////  CameraController.swift
////  AV Foundation
////
////  Created by Himanshu Ahuja on 17/05/18.
////  Copyright © 2018 Himanshu Ahuja. All rights reserved.
////
//
//import AVFoundation
//import UIKit
//
//class CameraController: NSObject {
//	var captureSession: AVCaptureSession?
//	
//	var currentCameraPosition: CameraPosition?
//	
//	var frontCamera: AVCaptureDevice?
//	var frontCameraInput: AVCaptureDeviceInput?
//	
//	var photoOutput: AVCapturePhotoOutput?
//	
//	var rearCamera: AVCaptureDevice?
//	var rearCameraInput: AVCaptureDeviceInput?
//	
//	var previewLayer: AVCaptureVideoPreviewLayer?
//	
//	var flashMode = AVCaptureDevice.FlashMode.off
//	
//	var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
//	
//}
//
//extension CameraController {
//	func prepare(completionHandler: @escaping (Error?) -> Void) {
//		func createCaptureSession() {
//			self.captureSession = AVCaptureSession()
//			self.captureSession?.sessionPreset = AVCaptureSession.Preset.high
//		}
//		
//		func configureCaptureDevices() throws {
//			let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
//			// adds the devices array to the session
//			let cameras = session.devices
//			if cameras.isEmpty { throw CameraControllerError.noCamerasAvailable }
//			
//			for camera in cameras {
//				// if the device position is .front, set the front camera property
//				// to that camera
//				if camera.position == .front {
//					self.frontCamera = camera
//				}
//				
//				if camera.position == .back {
//					self.rearCamera = camera
//					
//					try camera.lockForConfiguration()
//					camera.focusMode = .autoFocus
//					camera.unlockForConfiguration()
//				}
//			}
//		}
//		
//		func configureDeviceInputs() throws {
//			guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
//			
//			if let rearCamera = self.rearCamera {
//				self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
//				
//				if captureSession.canAddInput(self.rearCameraInput!) { captureSession.addInput(self.rearCameraInput!) }
//				
//				self.currentCameraPosition = .rear
//			}
//				
//			else if let frontCamera = self.frontCamera {
//				self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
//				
//				if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
//				else { throw CameraControllerError.inputsAreInvalid }
//				
//				self.currentCameraPosition = .front
//			}
//				
//			else { throw CameraControllerError.noCamerasAvailable }
//		}
//		
//		func configurePhotoOutput() throws {
//			guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
//			
//			self.photoOutput = AVCapturePhotoOutput()
//			self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
//			
//			if captureSession.canAddOutput(self.photoOutput!) {
//				captureSession.addOutput(self.photoOutput!) }
//			captureSession.startRunning()
//		}
//
//		DispatchQueue(label: "prepare").async {
//			do {
//				createCaptureSession()
//				try configureCaptureDevices()
//				try configureDeviceInputs()
//				try configurePhotoOutput()
//			}
//				
//			catch {
//				DispatchQueue.main.async {
//					completionHandler(error)
//				}
//				
//				return
//			}
//			
//			DispatchQueue.main.async {
//				completionHandler(nil)
//			}
//		}
//	}
//	// end of prepare
//	
//	func displayPreview(on view: UIView) throws {
//		guard let captureSession = self.captureSession, captureSession.isRunning
//			else { throw CameraControllerError.captureSessionIsMissing }
//		
//		self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//		self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//		self.previewLayer?.connection?.videoOrientation = .portrait
//		
//		view.layer.insertSublayer(self.previewLayer!, at: 0)
//		self.previewLayer?.frame = view.frame
//	}
//	// end of display preview
//	
////	func switchCameraMode() throws {
////		switch current
////	}
////	// end of camera mode switching
//	
//	func switchCameras() throws{
//		guard let currentCameraPosition = currentCameraPosition,
//			let captureSession = self.captureSession, captureSession.isRunning
//			else {throw CameraControllerError.captureSessionIsMissing}
//		
//		captureSession.beginConfiguration()
//		
//		func switchToFrontCamera() throws {
//			// get array of all the inputs in the capture session
//			// creates new input device
//			guard let inputs = captureSession.inputs as? [AVCaptureInput],
//				let rearCameraInput = self.rearCameraInput, inputs.contains(rearCameraInput),
//				let frontCamera = self.frontCamera
//				else {throw CameraControllerError.invalidOperation}
//			self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
//			
//			// remove the old input
//			captureSession.removeInput(rearCameraInput)
//			
//			// add the new input
//			if captureSession.canAddInput(self.frontCameraInput!){
//				captureSession.addInput(self.frontCameraInput!)
//				self.currentCameraPosition = .front
//			}
//			
//			else {
//				throw CameraControllerError.invalidOperation }
//		}
//		
//		
//		func switchToRearCamera() throws {
//			guard let inputs = captureSession.inputs as? [AVCaptureInput],
//			let frontCameraInput = self.frontCameraInput,
//				inputs.contains(frontCameraInput),
//			let rearCamera = self.rearCamera
//			else { throw CameraControllerError.invalidOperation}
//			
//			self.rearCameraInput = try AVCaptureDeviceInput(device: rearCamera)
//			
//			captureSession.removeInput(frontCameraInput)
//			
//			if captureSession.canAddInput(self.rearCameraInput!){
//				captureSession.addInput(self.rearCameraInput!)
//				self.currentCameraPosition = .rear
//			}
//			else {
//				throw CameraControllerError.invalidOperation
//			}
//			
//		}
//		
//		switch currentCameraPosition {
//		case .front:
//			try switchToRearCamera()
//		case .rear:
//			try switchToFrontCamera()
//		}
//		
//		captureSession.commitConfiguration()
//	}
//	// end of switch cameras function
//	
//	func captureImage(completion: @escaping (UIImage?, Error?) -> Void){
//		guard let captureSession = captureSession, captureSession.isRunning
//			else {completion(nil, CameraControllerError.captureSessionIsMissing); return}
//		let settings = AVCapturePhotoSettings()
//		settings.flashMode = self.flashMode
//		
//		self.photoOutput?.capturePhoto(with: settings, delegate: self)
//		self.photoCaptureCompletionBlock = completion
//	}
//	// end of capture Image function
//	
//	
//}
//
//extension CameraController {
//	enum CameraControllerError: Swift.Error {
//		case captureSessionAlreadyRunning
//		case captureSessionIsMissing
//		case inputsAreInvalid
//		case invalidOperation
//		case noCamerasAvailable
//		case unknown
//	}
//	
//	public enum CameraPosition {
//		case front
//		case rear
//	}
//}
//
//extension CameraController: AVCapturePhotoCaptureDelegate {
//	public func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
//						resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
//		if let error = error { self.photoCaptureCompletionBlock?(nil, error) }
//			
//		else if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
//			let image = UIImage(data: data) {
//			
//			self.photoCaptureCompletionBlock?(image, nil)
//		}
//			
//		else {
//			self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
//		}
//	}
//}
