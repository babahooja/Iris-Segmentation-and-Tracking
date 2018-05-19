//
//  FrameExtractor.swift
//  Iris
//
//  Created by Himanshu Ahuja on 19/05/18.
//  Copyright © 2018 Himanshu Ahuja. All rights reserved.
//


import UIKit
import AVFoundation

protocol FrameExtractorDelegate: class {
	// this protocol is initiated (called) whenever UIImage
	// is available
	func captured(image: UIImage)
}

class FrameExtractor: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
	
	private let position = AVCaptureDevice.Position.back
	private let quality = AVCaptureSession.Preset.high
	
	private var permissionGranted = false
	private let sessionQueue = DispatchQueue(label: "session queue")
	private let captureSession = AVCaptureSession()
	private let context = CIContext()
	
	/*to avoid a retain cycle, the delegate must be
	declared weak. Because it is declared weak, we add
	the class keyword to the protocol’s declaration.*/
	weak var delegate: FrameExtractorDelegate?
	
	override init() {
		super.init()
		// Overriding the init of the NSObject Protocol
		checkPermission()
		
		/*first we need to start the capture session and don’t
		forget that the capture session must be started on the
		dedicated serial queue we created before, as starting
		the session is a blocking call and we don’t want to
		block the UI.*/
		
		/*Remember that we have two queues in play here, one is
		the session queue, the other one is the queue each frame
		is sent to. They are different.*/
		
		sessionQueue.async { [unowned self] in
			self.configureSession()
			self.captureSession.startRunning()
		}
	}
	
	// MARK: AVSession configuration
	private func checkPermission() {
		switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
		case .authorized:
			permissionGranted = true
		case .notDetermined:
			requestPermission()
		default:
			permissionGranted = false
		}
	}
	
	private func requestPermission() {
		sessionQueue.suspend()
		AVCaptureDevice.requestAccess(for: AVMediaType.video) { [unowned self] granted in
			self.permissionGranted = granted
			self.sessionQueue.resume()
		}
	}
	
	private func configureSession() {
		// Get the permission
		guard permissionGranted else { return }
		
		// set the session qulaity
		captureSession.sessionPreset = quality
		
		// find the capture Device
		guard let captureDevice = selectCaptureDevice() else { return }
		
		// set the capture device to take input
		guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
		guard captureSession.canAddInput(captureDeviceInput) else { return }
		// add input to the capture session
		captureSession.addInput(captureDeviceInput)
		
		// The Frame Extractor class delegates to
		// receive uncompressed frames and process them.
		// creating an instance of video output into the frame extractor
		let videoOutput = AVCaptureVideoDataOutput()
		// Delegating frame extractor to the video output!
		videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
		
		//add an output to the capture session
		guard captureSession.canAddOutput(videoOutput) else { return }
		captureSession.addOutput(videoOutput)
		guard let connection = videoOutput.connection(with: AVFoundation.AVMediaType.video) else { return }
		guard connection.isVideoOrientationSupported else { return }
		guard connection.isVideoMirroringSupported else { return }
		connection.videoOrientation = .landscapeLeft
		connection.isVideoMirrored = position != .back
	}
	
	private func selectCaptureDevice() -> AVCaptureDevice? {
		let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position)
		return session.devices.first
	}
	
	// MARK: Sample buffer to UIImage conversion
	private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
		// transform the sample buffer to CVImageBuffer
		guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
		let ciImage = CIImage(cvPixelBuffer: imageBuffer)
		guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
		return UIImage(cgImage: cgImage)
	}
	
	// MARK: AVCaptureVideoDataOutputSampleBufferDelegate
	func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
		guard let uiImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
		DispatchQueue.main.async { [unowned self] in
			self.delegate?.captured(image: uiImage)
		}
	}
}

extension FrameExtractor {
	enum FrameExtractorError: Swift.Error {
		case permissionNotGranted
		case captureSessionAlreadyRunning
		case captureSessionIsMissing
		case inputsAreInvalid
		case invalidOperation
		case noCamerasAvailable
		case unknown
	}
}
