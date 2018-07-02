//
//  ViewController.m
//  VisionaryV10
//
//  Created by Himanshu Ahuja on 23/06/18.
//  Copyright © 2018 Himanshu Ahuja. All rights reserved.
//

#import "ViewController.h"
//#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#include <MobileCoreServices/MobileCoreServices.h>
#include <opencv2/core/utility.hpp>
#include <opencv2/tracking.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>


@interface ViewController () <UITabBarDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImagePickerController *videoPicker = [[UIImagePickerController alloc] init];
    videoPicker.delegate = self; // ensure you set the delegate so when a video is chosen the right method can be called
    
    videoPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    // This code ensures only videos are shown to the end user
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
    
    videoPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    [self presentViewController:videoPicker animated:YES completion:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // This is the NSURL of the video object
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    NSLog(@"VideoURL = %@", videoURL);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
