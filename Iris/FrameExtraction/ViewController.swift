//
//  ViewController.swift
//  Created by Bobo on 29/12/2016.
//

import UIKit
import Vision

class ViewController: UIViewController, FrameExtractorDelegate {
    
    @objc var frameExtractor: FrameExtractor!
    
    @IBOutlet weak var imageView: UIImageView!
	@IBOutlet fileprivate var toggleCameraButton: UIButton!
	
//	@IBOutlet weak var highlightView: UIView? {
//		didSet {
//			self.highlightView?.layer.borderColor = UIColor.red.cgColor
//			self.highlightView?.layer.borderWidth = 4
//			self.highlightView?.backgroundColor = .clear
//		}
//	}
	
    @IBAction func flipButton(_ sender: UIButton) {
        frameExtractor.flipCamera()
		if frameExtractor.position == .back {
//			frameExtractor.position = .front
			toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
			
		}
		else{
//			frameExtractor.position = .back
			toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
		}
    }
	
//	@IBAction private func userTapped(_ sender: UITapGestureRecognizer) {
//		// get the center of the tap
//		frameExtractor.highlightView?.frame.size = CGSize(width: 120, height: 120)
//		frameExtractor.highlightView?.center = sender.location(in: self.view)
//
//		let originalRect = frameExtractor.highlightView?.frame ?? .zero
//		var convertedRect = frameExtractor.cameraLayer.metadataOutputRectConverted(fromLayerRect: originalRect)
//		convertedRect.origin.y = 1 - convertedRect.origin.y
//
//		let newObservation = VNDetectedObjectObservation(boundingBox: convertedRect)
//		frameExtractor.lastObservation = newObservation
//	}

	
//	@IBAction func pinchToZoom(_ sender: UIPinchGestureRecognizer) {
//		frameExtractor.changeZoomLevel()
//
//
//		if sender.state == .changed {
//
//			let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
//			let pinchVelocityDividerFactor: CGFloat = 5.0
//
//			do {
//				
//				try device.lockForConfiguration()
//				defer { device.unlockForConfiguration() }
//
//				let desiredZoomFactor = device.videoZoomFactor + atan2(sender.velocity, pinchVelocityDividerFactor)
//				device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
//
//			} catch {
//				print(error)
//			}
//		}
//	}
	override var prefersStatusBarHidden: Bool { return true }
	
}
extension ViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()
        frameExtractor = FrameExtractor()
        frameExtractor.delegate = self
    }
    
    @objc func captured(image: UIImage) {
        imageView.image = image
    }
    
}

