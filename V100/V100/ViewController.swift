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

class ViewController: UIViewController,UIGestureRecognizerDelegate {
    // Add the outlets
    let containerView = UIView(frame: CGRect(x:0,y:0,width:440,height:600))
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var boundingbox: UIView!

    
    // Add the variables and constants
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var videoFrames:[UIImage] = []
    var positions: [CGRect] = []
    var sampleCountsView: Int32?
    let openCVWrapper = OpenCVWrapper()
    var initroi: CGRect!
    var timeArray: [Double] = []
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
        
        //add pan gesture
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        gestureRecognizer.delegate = self
        boundingbox.addGestureRecognizer(gestureRecognizer)
        
        //Enable multiple touch and user interaction for textfield
        boundingbox.isUserInteractionEnabled = true
        boundingbox.isMultipleTouchEnabled = true
        
        //add pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(pinch:)))
        pinchGesture.delegate = self
        boundingbox.addGestureRecognizer(pinchGesture)
        
        //add rotate gesture.
//        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
//        rotate.delegate = self
//        textField.addGestureRecognizer(rotate)
        
        // Set the properties of the bounding box object
//        boundingBox.layer.borderColor = UIColor.black.cgColor
//        boundingBox.isUserInteractionEnabled  = true
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
    }
    
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        
        if let view = pinch.view {
            view.transform = view.transform.scaledBy(x: pinch.scale, y: pinch.scale)
            pinch.scale = 1
        }
    }
    
//    func handleRotate(recognizer : UIRotationGestureRecognizer) {
//        if let view = recognizer.view {
//            view.transform = view.transform.rotated(by: recognizer.rotation)
//            recognizer.rotation = 0
//        }
//    }
    
    //MARK:- UIGestureRecognizerDelegate Methods
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
//    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: self.view)
//        if let view = recognizer.view {
//            view.center = CGPoint(x:view.center.x + translation.x,
//                                  y:view.center.y + translation.y)
//        }
//        recognizer.setTranslation(CGPoint.zero, in: self.view)
//    }
//
//    @IBAction func handlePinch(recognizer:UIPinchGestureRecognizer) {
//        if let view = recognizer.view {
//            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
//            recognizer.scale = 1
//        }
//    }
    
    @IBAction func startTracking(sender: UIButton) {
        print("You just pressed the button")
        let cx = boundingbox.frame.origin.x
        let cy = boundingbox.frame.origin.y
        let width = boundingbox.frame.width
        let height = boundingbox.frame.height
        let minx = cx - (width/2)
        let miny = cy - (height/2)
        self.initroi = CGRect(x: minx, y: miny, width: width, height: height)
//        print(roi)
        self.positions = openCVWrapper.processImage(videoFrames, initroi, sampleCountsView!) as! [CGRect]
        self.calculatePerformance()
        
        
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
    
    private func calculatePerformance(){
        print("")
        let base = self.calculateCenter(rect: initroi);
        let sampleCounts = 100
        var difx: [CGFloat] = []
        var dify: [CGFloat] = []
        difx.append(0.0)
        dify.append(0.0)
        print(self.timeArray[0], difx[0], dify[0])
        for i in 1 ..< sampleCounts {
            difx.append(base.x - positions[i].origin.x)
            dify.append(base.y - positions[i].origin.y)
            print (self.timeArray[i], difx[i], dify[i])
        }
        
    }
    private func calculateCenter(rect: CGRect) -> CGPoint {
        let sample: CGPoint  = CGPoint(x: rect.origin.x + rect.width, y: rect.origin.y + rect.height/2);
        return sample
    }

}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
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
                    self.timeArray.append(requestedTime.seconds)
                    let frameImg = UIImage(cgImage: image)
                    
                    let newImage = frameImg.rotate(radians: .pi/2)
                    let ratio = (newImage?.size.width)! / (newImage?.size.height)!
                    if self.containerView.frame.width > self.containerView.frame.height {
                        let newHeight = self.containerView.frame.width / ratio
                        self.avaImg.frame.size = CGSize(width: self.containerView.frame.width, height: newHeight)
                    }
                    else{
                        let newWidth = self.containerView.frame.height * ratio
                        self.avaImg.frame.size = CGSize(width: newWidth, height: self.containerView.frame.height)
                    }
                    self.videoFrames.append(newImage!)
                    if (k == 0){
                        
                        //displays only the first image in the view
                        self.avaImg.image = newImage
                        
                    }
                }
            }
        })
//        self.bringSubviewToFront(boundingbox)
    }
}

