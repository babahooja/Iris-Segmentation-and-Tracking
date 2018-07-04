//
//  ViewController.swift
//  V100
//
//  Created by Himanshu Ahuja on 01/07/18.
//  Copyright © 2018 Himanshu Ahuja. All rights reserved.
//
import UIKit
import MobileCoreServices
import CoreGraphics
import AVKit

class ViewController: UIViewController {
    // Add the outlets
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var boundingbox: UIView!
    
    // Add the variables and constants
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var videoFrames:[UIImage] = []
    var sampleCountsView: Int32?
    let openCVWrapper = OpenCVWrapper()
//    let boundingBox = BoundingBox()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.view.addSubview(boundingBox)
        self.openImgPicker()
        boundingbox.layer.borderColor = UIColor.red.cgColor
        boundingbox.layer.borderWidth = 2.0
        boundingbox.backgroundColor = UIColor.black.withAlphaComponent(0)
        boundingbox.isOpaque = false

        // Set the properties of the bounding box object
//        boundingBox.layer.borderColor = UIColor.black.cgColor
//        boundingBox.isUserInteractionEnabled  = true
    }
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @IBAction func handlePinch(recognizer:UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    @IBAction func startTracking(sender: UIButton) {
        print("You just pressed the button")
        let cx = boundingbox.frame.origin.x
        let cy = boundingbox.frame.origin.y
        let width = boundingbox.frame.width
        let height = boundingbox.frame.height
        let minx = cx - (width/2)
        let miny = cy - (height/2)
        let roi = CGRect(x: minx, y: miny, width: width, height: height)
//        print(roi)
        openCVWrapper.processImage(videoFrames, roi, sampleCountsView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func openImgPicker() {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    }

}

extension UIPinchGestureRecognizer {
    func scale(view: UIView) -> (x: CGFloat, y: CGFloat)? {
        if numberOfTouches > 1 {
            let touch1 = self.location(ofTouch: 0, in: view)
            let touch2 = self.location(ofTouch: 1, in: view)
            let deltaX = abs(touch1.x - touch2.x)
            let deltaY = abs(touch1.y - touch2.y)
            let sum = deltaX + deltaY
            if sum > 0 {
                let scale = self.scale
                return (1.0 + (scale - 1.0) * (deltaX / sum), 1.0 + (scale - 1.0) * (deltaY / sum))
            }
        }
        return nil
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.videoURL = info[UIImagePickerControllerMediaURL] as? URL
        print("videoURL:\(String(describing: self.videoURL))")
        self.dismiss(animated: true, completion: nil)
        let asset:AVAsset = AVAsset(url:self.videoURL!)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceAfter = kCMTimeZero
        generator.requestedTimeToleranceBefore = kCMTimeZero
        let videoDuration = asset.duration
        
        var frameForTimes = [NSValue]()
//        let fps = asset.tracks[0].nominalFrameRate
//        let sampleCounts = Int(Float(videoDuration.seconds) * fps)
        let sampleCounts = 100
        self.sampleCountsView = Int32(sampleCounts)
        let totalTimeLength = Int(videoDuration.seconds * Double(videoDuration.timescale))
        let step = totalTimeLength / sampleCounts
        
        for i in 0 ..< sampleCounts {
            let cmTime = CMTimeMake(Int64(i * step), Int32(videoDuration.timescale))
            frameForTimes.append(NSValue(time: cmTime))
        }
        
        generator.generateCGImagesAsynchronously(forTimes: frameForTimes, completionHandler: {requestedTime, image, actualTime, result, error in
            DispatchQueue.main.async {
                if let image = image {
                    let k = requestedTime.value
                    print(requestedTime.value, requestedTime.seconds, actualTime.value)
                    let frameImg = UIImage(cgImage: image)
                    self.videoFrames.append(frameImg)
                    if (k == 0){
                        //displays only the first image in the view
                        self.avaImg.image = frameImg
                    }
                }
            }
        })
//        self.bringSubviewToFront(boundingbox)
    }
}

