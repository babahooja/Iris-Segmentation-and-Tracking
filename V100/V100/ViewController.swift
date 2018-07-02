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
    
    var imagePickerController = UIImagePickerController()
    var videoURL: URL?
    var videoFrames:[UIImage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.openImgPicker()
        //Get the frames
    
        let asset:AVAsset = AVAsset(url:(self.videoURL)!)
        let mutableVideoDuration = CMTimeGetSeconds(asset.duration)
//        let mutableVideoDurationIntValue = Int(mutableVideoDuration)
        let assetImgGenerate:AVAssetImageGenerator = AVAssetImageGenerator(asset:asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
//        let duration:Float64 = CMTimeGetSeconds(asset.duration)
        let durationInt:Int = Int(mutableVideoDuration)
        
        for index:Int in 0 ..< durationInt
        {
            generateFrames(assetImgGenerate:assetImgGenerate, fromTime:Float64(index))
        }
        
        let openCVWrapper = OpenCVWrapper()
        openCVWrapper.isThisWorking()
        
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
        self.videoFrames.append(frameImg)
    }
    
    private func openImgPicker() {
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = [kUTTypeMovie as NSString as String]
        present(imagePickerController, animated: true, completion: nil)
    }
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        videoURL = info[UIImagePickerControllerMediaURL] as? URL
        print("videoURL:\(String(describing: videoURL))")
        self.dismiss(animated: true, completion: nil)
    }
}

