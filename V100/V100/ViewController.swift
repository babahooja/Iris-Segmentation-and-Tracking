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

/////////////////////////////////////////////////////////////////////////////////
////////////////////////////// SAFE CODE ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


class ViewController: UIViewController {
    @IBOutlet weak var avaImg: UIImageView!


    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var videoFrames:[UIImage] = []
//    let sampleCounts = 1
    let overlay = UIView()
    var lastPoint = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.openImgPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func generateFrames(assetImgGenerate:AVAssetImageGenerator,fromTime:Float64){
        let time:CMTime = CMTimeMakeWithSeconds(fromTime, 600)
        let cgImage:CGImage?

        do{
            cgImage = try assetImgGenerate.copyCGImage(at:time, actualTime:nil)
        }
        catch{
            cgImage = nil
        }

        guard let img:CGImage = cgImage else {return}

        let frameImg:UIImage = UIImage(cgImage:img)
        avaImg.image = frameImg
        
        self.videoFrames.append(frameImg)
        print(videoFrames.count)
    }

    private func openImgPicker() {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Draw a rectangle over the first image
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        //Save original tap Point
        if let touch = touches.first {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Get the current known point and redraw
        if let touch = touches.first {
            let currentPoint = touch.locationInView(view)
            reDrawSelectionArea(lastPoint, toPoint: currentPoint)
        }
    }
    
    func reDrawSelectionArea(fromPoint: CGPoint, toPoint: CGPoint) {
        overlay.hidden = false
        
        //Calculate rect from the original point and last known point
        let rect = CGRectMake(min(fromPoint.x, toPoint.x),
                              min(fromPoint.y, toPoint.y),
                              fabs(fromPoint.x - toPoint.x),
                              fabs(fromPoint.y - toPoint.y));
        
        overlay.frame = rect
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        overlay.hidden = true
        
        //User has lift his finger, use the rect
        applyFilterToSelectedArea(overlay.frame)
        
        overlay.frame = CGRectZero //reset overlay for next tap
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.videoURL = info[UIImagePickerControllerMediaURL] as? URL
        print("videoURL:\(String(describing: self.videoURL))")
        self.dismiss(animated: true, completion: nil)
        print("Hello")
        let asset:AVAsset = AVAsset(url:self.videoURL!)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceAfter = kCMTimeZero
        generator.requestedTimeToleranceBefore = kCMTimeZero
        let videoDuration = asset.duration
        
        var frameForTimes = [NSValue]()
        let fps = asset.tracks[0].nominalFrameRate
        let sampleCounts = Int(Float(videoDuration.seconds) * fps)
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
                    self.videoFrames.append(UIImage(cgImage: image))
                    if (k == 0){
                        
                    }
                }
            }
        })
        
        let openCVWrapper = OpenCVWrapper()
        openCVWrapper.processImage(self.videoFrames)
        
//        let asset:AVAsset = AVAsset(url:self.videoURL!)
//        let mutableVideoDuration = CMTimeGetSeconds(asset.duration)
//        //        let mutableVideoDurationIntValue = Int(mutableVideoDuration)
//        let assetImgGenerate:AVAssetImageGenerator = AVAssetImageGenerator(asset:asset)
//        assetImgGenerate.appliesPreferredTrackTransform = true
//        //        let duration:Float64 = CMTimeGetSeconds(asset.duration)
//        let durationInt:Int = Int(mutableVideoDuration)
//
//        for index:Int in 0 ..< durationInt
//        {
//            generateFrames(assetImgGenerate:assetImgGenerate, fromTime:Float64(index))
//        }
        
    }
}

