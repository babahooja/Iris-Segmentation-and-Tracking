//
//  FrameExtractor.swift
//  Created by Himanshu Ahuja on 30/12/2016.
//

import UIKit
import AVFoundation

protocol FrameExtractorDelegate: class {
    func captured(image: UIImage)
}

class FrameExtractor: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
	
	////////////////////////////////////////////////////////////////
	var position = AVCaptureDevice.Position.back
    private let quality = AVCaptureSession.Preset.high
    
    private var permissionGranted = false
    private let sessionQueue = DispatchQueue(label: "session queue")
    private let captureSession = AVCaptureSession()
//	let cameraLayer = AVCaptureVideoPreviewLayer()
    private let context = CIContext()
    
    weak var delegate: FrameExtractorDelegate?
	
//	weak var highlightView: UIView? {
//		didSet {
//			self.highlightView?.layer.borderColor = UIColor.red.cgColor
//			self.highlightView?.layer.borderWidth = 4
//			self.highlightView?.backgroundColor = .clear
//		}
//	}
//
	
	// Variables and instance for Vision module (Tracking)
	//////////////////////////////////////////////////////////////
//	let visionSequenceHandler = VNSequenceRequestHandler()
	/*The vision sequence system works in a loop. You provide a
	"seed" observation, then feed that into the vision system.
	The vision system then outputs a new observation.*/
//	var lastObservation: VNDetectedObjectObservation?
	/////////////////////////////////////////////////////////////
	
    
    override init() {
        super.init()
        checkPermission()
        sessionQueue.async { [unowned self] in
            self.configureSession()
            self.captureSession.startRunning()
        }
    }
}
extension FrameExtractor {
	
	// Asynchronous call to toggle Camera
    @objc public func flipCamera() {
        sessionQueue.async { [unowned self] in
            self.captureSession.beginConfiguration()
			guard let currentCaptureInput = self.captureSession.inputs.first else { return }
            self.captureSession.removeInput(currentCaptureInput)
			guard let currentCaptureOutput = self.captureSession.outputs.first else { return }
            self.captureSession.removeOutput(currentCaptureOutput)
            self.position = self.position == .front ? .back : .front
            self.configureSession()
            self.captureSession.commitConfiguration()
        }
    }
	
	
	// Asynchronous call to change zoom level
//	@objc public func changeZoomLevel() {
//		sessionQueue.async { [unowned self] in
//			self.captureSession.beginConfiguration()
//			guard let currentCaptureInput = self.captureSession.inputs.first else {return}
//
//
//
//			guard let device = captureDevice else { return }
//			if sender.state == .changed {
//
//				let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
//				let pinchVelocityDividerFactor: CGFloat = 5.0
//
//				do {
//
//					try device.lockForConfiguration()
//					defer { device.unlockForConfiguration() }
//
//					let desiredZoomFactor = device.videoZoomFactor + atan2(sender.velocity, pinchVelocityDividerFactor)
//					device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
//
//				} catch {
//					print(error)
//				}
//			}
//		}
	
//	}
	
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
        guard permissionGranted else { return }
        captureSession.sessionPreset = quality
        guard let captureDevice = selectCaptureDevice() else { return }
		
		// setting autofocus
		if(captureDevice.isFocusModeSupported(.continuousAutoFocus)) {
			try! captureDevice.lockForConfiguration()
			captureDevice.focusMode = .continuousAutoFocus
			captureDevice.unlockForConfiguration()
		}
		
        guard let captureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        guard captureSession.canAddInput(captureDeviceInput) else { return }
        captureSession.addInput(captureDeviceInput)
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer"))
        guard captureSession.canAddOutput(videoOutput) else { return }
        captureSession.addOutput(videoOutput)
        guard let connection = videoOutput.connection(with: AVFoundation.AVMediaType.video) else { return }
        guard connection.isVideoOrientationSupported else { return }
        guard connection.isVideoMirroringSupported else { return }
        connection.videoOrientation = .portrait
        connection.isVideoMirrored = position == .front
    }
    
    private func selectCaptureDevice() -> AVCaptureDevice? {
		return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: position).devices.first
    }
    
    // MARK: Sample buffer to CGImage conversion
    private func coreGraphicsFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard
			let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
		else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
		return cgImage
    }
	
	
	private func imageFromCoreGraphics(cgImage: CGImage) -> UIImage? {
		return UIImage(cgImage: cgImage)
	}
    
    // MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard
			let cgImage = coreGraphicsFromSampleBuffer(sampleBuffer: sampleBuffer),
			let uiImage = imageFromCoreGraphics(cgImage: cgImage)
//			let lastObservation = self.lastObservation
		else { return }
		
//		let request = VNTrackObjectRequest(detectedObjectObservation: lastObservation, completionHandler: self.handleVisionRequestUpdate)
//		request.trackingLevel = .accurate
//
//		// perform the request
//		do {
//			try self.visionSequenceHandler.perform([request], on: cgImage)
//		} catch {
//			print("Throws: \(error)")
//		}
		
		DispatchQueue.main.async { [unowned self] in
			self.delegate?.captured(image: uiImage)
		}
		
    }
	
	// Handling updates from the Vision Request handler
//	private func handleVisionRequestUpdate(_ request: VNRequest, error: Error?) {
//		DispatchQueue.main.async { [unowned self] in
//			guard let newObservation = request.results?.first as? VNDetectedObjectObservation else { return }
//
//			// prepare for next loop
//			self.lastObservation = newObservation
//
//			guard newObservation.confidence >= 0.3 else {
//				// hide the rectangle when we lose accuracy so the user knows something is wrong
//				self.highlightView?.frame = .zero
//				return
//			}
//
//
//			var transformedRect = newObservation.boundingBox
//			transformedRect.origin.y = 1 - transformedRect.origin.y
//			let convertedRect = self.cameraLayer.layerRectConverted(fromMetadataOutputRect: transformedRect)
//
//			// move the highlight view
//			self.highlightView?.frame = convertedRect
//		}
//	}
}

